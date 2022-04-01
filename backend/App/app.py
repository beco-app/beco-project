import sys
import os
from datetime import datetime, timedelta
from bson.objectid import ObjectId
from bson import json_util

local = True
if local:
    sys.path.append("/Users/tomas.gadea/tomasgadea/ACADEMIC/GCED/q6/PE/beco/beco-project")
else:
    sys.path.append("/home/ubuntu/beco-project")

from backend.data_base import tools
from backend.App.validate import validate_promotion, validate_user_exists, validate_unique_username

#import firebase_admin
#import pyrebase
import json
#from firebase_admin import credentials, auth
from flask import Flask, request
from functools import wraps
import logging

# App configuration
app = Flask(__name__)

# Connect to firebase
#cred = credentials.Certificate('backend/App/fbAdminConfig.json')
#firebase = firebase_admin.initialize_app(cred)
#pb = pyrebase.initialize_app(json.load(open('backend/App/fbconfig.json')))

# Data source
users = [{'uid': 1, 'name': 'Yikai Qiu'}]


def check_token(f):
    @wraps(f)
    def wrap(*args,**kwargs):
        if not request.headers.get('authorization'):
            return {'message': 'No token provided'},400
        try:
            user = auth.verify_id_token(request.headers['authorization'])
            request.user = user
        except:
            return {'message':'Invalid token provided.'},400
        return f(*args, **kwargs)
    return wrap


# Test
@app.route('/')
def hello_world():
    return 'Hello from Flask!', 200

# Api route to get userso
@app.route('/api/userinfo')
@check_token
def userinfo():
    return {'data': users}, 200

# Api route to sign up a new user
@app.route('/api/signup')
def signup():
    email = request.form.get('email')
    password = request.form.get('password')

    if email is None or password is None:
        return {'message': 'Error missing email or password'},400
    try:
        user = auth.create_user(
            email=email,
            password=password
        )
        return {'message': f'Successfully created user {user.uid}'},200
    except:
        return {'message': 'Invalid email or password'},400

# Api route to get a new token for a valid user
@app.route('/api/token')
def token():
    email = request.form.get('email')
    password = request.form.get('password')
    try:
        user = pb.auth().sign_in_with_email_and_password(email, password)
        jwt = user['idToken']
        return {'token': jwt}, 200
    except:
        return {'message': 'There was an error logging in'},400


@app.route("/api/login", methods=['POST'])
@validate_user_exists
def login():
    data = request.form.to_dict()
    fields = {"email", "password"}
    if fields != data.keys():
        return {"message": "Invalid data fields"}, 400

    user = tools.getUser({"email": data["email"]}, attributes=["password"])
    print(user)
    return user

    if data["password"] != user["password"]:
        return {"message": "wrong password!"}, 400

    return {"message": "success", "user_id": user["_id"]}, 200

# Write user to database
@app.route('/api/register_user', methods=['POST'])
@validate_unique_username
def register_user():
    """
        Register new user to the database, which also has been previously added to firestore
    """

    data = request.form.to_dict()
    becoins = 0 # Initial becoins

    fields = {"email", "password", "phone", "gender", "birthdate", "zipcode", "diet"}
    if fields != data.keys():
        return {"message": "Invalid data fields"}, 400

    if data["email"] is None:
        return {'message': 'Invalid email'}, 400

    if data["password"] is None:
        return {'message': 'Invalid password'}, 400

    data = {
        'username': data["email"],
        'email': data["email"],
        'password': data["password"],
        'phone': data["phone"],
        'gender': data["gender"],
        'birthdate': data["birthdate"],
        'zip_code': data["zipcode"],
        'diet': data["diet"],
        'becoins': becoins,
        'saved_prom' : None
    }
    try:
        # Afegir 
        tools.setUser(data)
        return {'message': 'Success'}, 200
    except:
        return {'message': 'Error in updating database'}, 400

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
@app.route('/user_info/<username>')
def get_user(username):
    usr = tools.getUser(username=username)
    if not usr:
        return {'message': 'User not found'}, 404
    else:
        return str(usr), 200

# Get recommended shops
@app.route('/recommended/<username>')
def recommended_shops(username):
    return 0

# Get nearest shops
@app.route('/nearest_shops/<username>/<lat>/<long>/<distance>', methods=['POST'])
def nearest_shops(username, lat, long, distance):
    username = request.form.get('username')
    [lat, lon] = [request.form.get('latitude'), request.form.get('longitude')]
    max_distance = request.form.get('max_distance')
    return 0


# Add BECOINS
@app.route('/api/add_becoins', methods=["GET"])
def add_becoins():
    """
        Adds becoins to a user's account
        The amount and the user is passed in the data content of the request
        TODO: Add some security by requiring a token or something
    """
    user = request.form.get('username')
    becoins = request.form.get('becoins')
    try:
        # updateUser(username=user, becoins=becoins)
        return 0
    except:
        return {'message': 'Error'}, 404


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

    exp_date = datetime.now() + timedelta(days=1) # Set expiration date to 24h from the activation

    # Subtract becoins
    user = tools.getUser(_id = ObjectId(user_id))[0]
    cost = tools.getPromotion('becoins', _id = ObjectId(promotion_id))[0]['becoins']
    tools.updateUser(user['_id'], becoins = user['becoins'] - cost)
    
    # Write to db
    res = tools.setActivePromotion({'prom_id': ObjectId(promotion_id), 'user_id': ObjectId(user_id), 'valid_until': exp_date})

    # Debug:
    return str(tools.getActivePromotion(['valid_until'], user_id=user_id)[0]) + str(res), 200


# @app.route('/promotions/use', method=['POST'])
# @validate_user_exists
# def use_promotion():
#     transaction()
#     return 200



# Map Page
@app.route("/load_map", methods=["GET"])
def load_map():
    data = request.form.to_dict()
    shops = tools.getShop(["_id","address", "location", "shopname", "phone", "neighbourhood"]) # all shops
    shops_dict = {"shops": shops}
    response = json.loads(json_util.dumps(shops_dict))

    return response, 200

if __name__ == '__main__':
    app.run(debug=True)
