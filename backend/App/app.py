import sys
print("Python version")
print (sys.version)
print("Version info.")
print (sys.version_info)



import sys
import os
from datetime import datetime, timedelta
import pymongo
from bson import json_util
from bson.objectid import ObjectId

sys.path.append(os.getcwd())

from backend.data_base import tools
from backend.App.validate import validate_promotion, validate_user_exists, validate_unique_username

from backend.data_base.recommender import recommend
from backend.data_base.shops_aqi import get_shop_aqi


import json
from flask import Flask, request
from functools import wraps
from time import time

from backend.data_base.db_handler import queryFind

import ast

# App configuration
app = Flask(__name__)


# Test
@app.route('/')
def hello_world():
    return 'Hello from BECO!', 200


@app.route("/api/login", methods=['POST'])
@validate_user_exists
def login():
    data = request.form.to_dict()
    fields = {"email", "password"}
    if fields != data.keys():
        return {"message": "Invalid data fields"}, 400

    user = tools.getUser({"email": data["email"]}, attributes=["password"])
    return user

    if data["password"] != user["password"]:
        return {"message": "wrong password!"}, 400

    return {"message": "success", "user_id": user["_id"]}, 200

# Write user to database
@app.route('/register_user', methods=['POST'])
@validate_unique_username
def register_user():
    """
        Register new user to the database, which also has been previously added to firestore
    """

    req = request.form.to_dict()
    becoins = 0 # Initial becoins


    #req = json.loads(list(req.keys())[0])

    #fields = {"email", "password", "phone", "gender", "birthday", "zipcode", "preferences"}
    #if fields != req.keys():
    #    return {"message": "Invalid data fields"}, 400

    if req["email"] is None:
        return {'message': 'Invalid email'}, 400

    if req["password"] is None:
        return {'message': 'Invalid password'}, 400
    data = {
        'username': req["email"],
        'email': req["email"],
        'password': req["password"],
        'phone': req["phone"],
        'gender': req["gender"],
        'birthday': req["birthday"],
        'zip_code': req["zipcode"],
        'preferences': req["preferences"][1:-1].replace("'", "").split(", "),
        'becoins': becoins,
        'saved_prom' : None
    }
    #'preferences': data["preferences"],

    if "user_id" in req.keys():
        data["_id"] = req["user_id"] # firebase user_id
    #try:
        # Afegir 
    tools.setUser(data)
    return {'message': 'Success'}, 200
    #except:
    #    return {'message': 'Error in updating database'}, 400

@app.route('/api/remove_user', methods=['POST'])
@validate_user_exists
def remove_user():
    """
        Delete existing user from the database. Nothing changed in firebase
    """
    data = request.form.to_dict()
    if "user_id" in data.keys():
        deleted_count = tools.removeUserById(user_id=data['user_id'])
    elif "username" in data.keys():
        deleted_count = tools.removeUserByUsername(username=data['username'])

    return str(deleted_count), 200


# Get info from username
"""@app.route('/user_info/<username>')
def get_user(username):
    usr = tools.getUser(username=username)
    if not usr:
        return {'message': 'User not found'}, 404
    else:
        return str(usr), 200"""

# Get shop info from shopid
@app.route('/shop_info', methods=['POST'])
def get_shop_info():
    """
    Given the shopid, returns the shop info.
    """
    shopid = request.form.get('shop_id')
    print("shop_id", shopid)
    shop = tools.getShop(["_id","address", "location", "shopname", "neighbourhood", "description", "photo",  "type", "tags", "web"], _id=ObjectId(shopid))[0]
    # dict = {"shop": shop}
    shop['aqi'] = get_shop_aqi(shop['_id'])
    response = json.loads(json_util.dumps(shop))
    return response, 200

# Get info from user id
@app.route('/user_info/', methods=['POST'])
def get_user():
    data = request.form.to_dict()
    user_id = data['user_id']
    try:
        user_id = ObjectId(user_id)
    except:
        print("user_id from firebase")
    # Això de posar [0] està bé?
    resp = tools.getUser(["email", "password", "phone", "gender", "birthday", "zip_code", "preferences", "becoins"], _id = user_id)[0]
    resp = json.loads(json_util.dumps(resp))
    return resp, 200

# Get recommended shops
@app.route('/recommended_shops/', methods=['POST'])
def recommended_shops():
    data = request.form.to_dict()
    user_id = data['user_id']
    user_lat = float(data['user_lat']) if data['user_lat'] != '' else None
    user_lon = float(data['user_lon']) if data['user_lat'] != '' else None
    try:
        user_id = ObjectId(user_id)
    except:
        print("user_id from firebase")

    if user_lat is None and user_lon is None:
        location = [41.4034789, 2.174410333009705] # Suposem que està a Sagrada Família
    else:
        location = [user_lat, user_lon]
    resp = recommend(user_id, location)
    shops = []
    for shop_id, score in resp:
        # print("shop_id", shop_id)
        shop_content = tools.getShop(_id=shop_id)
        shop_content[0]['aqi'] = get_shop_aqi(shop_id)
        shops.append(shop_content[0])
    shops_dict = {"shops": shops}
    response = json.loads(json_util.dumps(shops_dict))
    return response, 200

# Get nearest shops
@app.route('/nearest_shops/<username>/<lat>/<long>/<distance>', methods=['POST'])
def nearest_shops(username, lat, long, distance):
    username = request.form.get('username')
    [lat, lon] = [request.form.get('latitude'), request.form.get('longitude')]
    max_distance = request.form.get('max_distance')
    return 0


# Add BECOINS
@app.route('/api/add_becoins', methods=["POST"])
def add_becoins():
    """
        Adds becoins to a user's account
        The amount and the user is passed in the data content of the request
        TODO: Add some security by requiring a token or something
    """

    try:
        userid = request.form.get('user_id')
        becoins_gained = int(request.form.get('becoins'))

        user = tools.getUser(attributes='becoins', _id=userid)[0]
        becoins_initial = user['becoins']

        if becoins_initial + becoins_gained < 0:
            raise Exception("You cannot have negative amount of becoins.")
        _, changed = tools.update(_id=userid, becoins=becoins_initial+becoins_gained)
        return f"Changed {changed} users."
    except Exception as e:
        return {'message': e}, 404

# Activate promotion
@app.route('/promotions/activate', methods=['POST'])
@validate_user_exists
@validate_promotion
def activate_promotion():
    """
    Activates a promotion for a given user, and sets its expiration date.
    """
    user_id = request.form.get('user_id')
    promotion_id = request.form.get('promotion_id')

    exp_date = (datetime.now() + timedelta(days=1)).timestamp() # Set expiration date to 24h from the activation

    # Subtract becoins
    user = tools.getUser(_id = ObjectId(user_id))[0]
    cost = tools.getPromotion('becoins', _id = ObjectId(promotion_id))[0]['becoins']
    tools.updateUser(user['_id'], becoins = user['becoins'] - cost)
    
    # Write to db
    res = tools.setActivePromotion({'prom_id': ObjectId(promotion_id), 'user_id': ObjectId(user_id), 'valid_until': exp_date})

    # Debug:
    return str(tools.getActivePromotion(['valid_until'], user_id=user_id)[0]) + str(res), 200

# Save promotion
@app.route('/promotions/save', methods=['POST'])
# @validate_user_exists
def save_promotion():
    """
    Saves a promotion for a given user.
    """
    user_id = request.form.get('user_id')
    promotion_id = request.form.get('promotion_id')

    try:
        user_id = ObjectId(user_id) # ObjectId must be a 12-byte input or a 24-character hex string
    except:
        print("Exception")

    # Append promotion_id to user's saved_prom
    user_saved_prom = tools.getUser(['saved_prom'], _id = user_id)[0]['saved_prom']
    if user_saved_prom and ObjectId(promotion_id) not in user_saved_prom:
        user_saved_prom.append(ObjectId(promotion_id))
        tools.updateUser(user_id, saved_prom=user_saved_prom)
    
    # Debug:
    return (
        (
            str(tools.getUser(['saved_prom'], _id = user_id)[0]['saved_prom']) +
            '\n' + promotion_id),
        200
    )

# Unsave promotion
@app.route('/promotions/unsave', methods=['POST'])
# @validate_user_exists
# @validate_promotion
def unsave_promotion():
    """
    Unsaves a promotion for a given user.
    """
    user_id = request.form.get('user_id')
    promotion_id = request.form.get('promotion_id')

    try:
        user_id = ObjectId(user_id) # ObjectId must be a 12-byte input or a 24-character hex string
    except:
        print("Exception")

    # Deletes promotion_id from user's saved_prom
    user_saved_prom = tools.getUser(['saved_prom'], _id = user_id)[0]['saved_prom']
    if ObjectId(promotion_id) not in user_saved_prom:
        raise ValueError(f'Promotion {promotion_id} not saved for user {user_id}')
    
    user_saved_prom.remove(ObjectId(promotion_id))
    tools.updateUser(user_id, saved_prom=user_saved_prom)
    
    # Debug:
    return (
        (
            str(tools.getUser(['saved_prom'], _id = user_id)[0]['saved_prom']) +
            '\n' + promotion_id),
        200
    )

def add_shop_name_in_proms_list(proms_list):
    """
    Adds the shop name to the list of promotions
    """
    for prom in proms_list:
        prom['shopname'] = tools.getShop(['shopname'], _id = ObjectId(prom['shop_id']))[0]
    return proms_list

# Get saved promotions
@app.route('/promotions/saved', methods=['POST'])
# @validate_user_exists
def saved_promotions():
    """
    Returns saved promotions list for a given user.
    """
    user_id = request.form.get('user_id')
    print("User_id", user_id)
    try:
        user_id = ObjectId(user_id) # ObjectId must be a 12-byte input or a 24-character hex string
    except:
        print("Exception")
    print("User_id", user_id)
    # Itererate over user's saved_prom and checks if it's still valid
    print("promos", tools.getUser('saved_prom', _id = user_id))
    saved_prom = tools.getUser('saved_prom', _id = user_id)[0]['saved_prom']
    now = time()
    if saved_prom:
        saved_prom = [
            prom_id
            for prom_id in saved_prom
        # if tools.getPromotion(['valid_interval'], _id = prom_id)[0]['valid_interval']['from'] < now < tools.getPromotion(['valid_interval'], _id = prom_id)[0]['valid_interval']['to']
            
        ]
    tools.updateUser(user_id, saved_prom=saved_prom)
    
    # user_saved_prom.remove(ObjectId(promotion_id))
    
    promotions = [tools.getPromotion(_id = prom_id)[0] for prom_id in saved_prom]
    promotions = add_shop_name_in_proms_list(promotions)
    response = json.loads(json_util.dumps({"promotions": promotions}))
    return response, 200

# Get activated promotions
@app.route('/promotions/activated', methods=['GET'])
@validate_user_exists
def activated_promotions():
    """
    Returns activated promotions list for a given user.
    """
    user_id = request.form.get('user_id')

    user_active_proms = queryFind(
        'beco_db', 'active_promotions', {'user_id' : ObjectId(user_id)}
    )
    user_active_proms = [
        tools.getPromotion(_id = prom['prom_id'])[0]
        for prom in user_active_proms
    ]
    user_active_proms = add_shop_name_in_proms_list(user_active_proms)
    response = json.loads(
        json_util.dumps({'user_active_proms': user_active_proms})
    )
    return response, 200   

# Get recent promotions
@app.route('/promotions/recent', methods=['GET'])
def recent_promotions():
    """
    Returns the most recent promotions.
    """

    now = time()
    most_recent = queryFind(
        'beco_db', 'promotions',
        {
            'valid_interval.to' : {'$gte': now},
            'valid_interval.from' : {'$lte': now}
        }
    ).sort('valid_interval.from', -1).limit(10)
    
    most_recent = add_shop_name_in_proms_list(list(most_recent))
    response = json.loads(json_util.dumps({'recent_proms': list(most_recent)}))
    return response, 200    

# @app.route('/promotions/use', method=['POST'])
# @validate_user_exists
# def use_promotion():
#     transaction()
#     return 200

@app.route('/promotions/shop_promotions', methods=['POST'])
def shop_promotions():
    """
    Returns the promotions for a given shop.
    """
    shop_id = request.form.get('shop_id')
    promotions = tools.getPromotion(['_id', 'description', 'becoins', 'valid_interval', 'shop_id'], shop_id = ObjectId(shop_id))

    promotions = add_shop_name_in_proms_list(promotions)
    response = json.loads(json_util.dumps({"promotions": promotions}))
    return response, 200


@app.route("/homepage", methods=["GET"])
def homepage():
    data = request.form.to_dict()
    shops = tools.getShop(["_id", "address", "location", "shopname", "neighbourhood", "description", "photo", "type", "tags", "web"])
    shops_dict = {"shops": shops}
    response = json.loads(json_util.dumps(shops_dict))

    return response, 200


# Map Page
@app.route("/load_map", methods=["GET"])
def load_map():
    data = request.form.to_dict()
    shops = tools.getShop(["_id","address", "location", "shopname", "neighbourhood", "description", "photo",  "type", "tags", "web"])
    shops_aqi = []
    for shop in shops:
        shop['aqi'] = get_shop_aqi(shop['_id'])
        shops_aqi.append(shop)
    
    shops_dict = {"shops": shops_aqi}
    response = json.loads(json_util.dumps(shops_dict))

    return response, 200

# Get info from username
@app.route('/user_update', methods=['POST'])
def update_user():
    """
    Given the attributes in POST, update a user.
    """


    data = request.form.to_dict()

    fields = {"id", "email", "password", "phone", "gender", "birthday", "zipcode", "preferences", "becoins"}

    if fields != data.keys():
        return {"message": "Invalid data fields"}, 400

    if data["email"] is None:
        return {'message': 'Invalid email'}, 400

    if data["password"] is None:
        return {'message': 'Invalid password'}, 400

    data = {
        'phone': data["phone"],
        'gender': data["gender"],
        'birthday': data["birthday"],
        'zip_code': data["zipcode"],
        'preferences': data["preferences"][1:-1].replace('"', "").split(", ") 
                        if data['preferences'] != '[]'
                        else [],
    }
    try:

        matches, _ = tools.updateUser(request.form.to_dict()['id'], **data)


        if matches:
            return {'message': 'Success'}, 200
        else:
            return {'message': 'No user found'}, 400
    except:
        return {'message': 'Error in updating database'}, 400
    

if __name__ == '__main__':
    app.run(debug=True)
