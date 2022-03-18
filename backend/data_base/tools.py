"""
IMPLEMENTED:
    * Ensure that the names of the attributes are well-defined in getters.

TO IMPLEMENT:
    * Remove or update of records?
    * Check the business rules in setters
    * Getteres with query that supports >, <, <=, ...
    * Add a `limit` parameter to limit the size of the output of getters
        (the parameter is already in db_handler.py file)
"""

from site import getusersitepackages
import pymongo
from bson.objectid import ObjectId
from . import db_handler # using relative path
import re
# import os
import json

# Globals
config = json.load(open("backend/config/config.json"))
db_username = config["db_username"]
db_password = config["db_password"]
db_name = config["db_name"]
db_users = config["db_users"]
db_shops = config["db_shops"]
db_transactions = config["db_transactions"]
db_promotions = config["db_promotions"]
db_active_promotions = config["db_active_promotions"]
db_products = config["db_products"]

collection_attributes = {
    db_users: [
        '_id','username','email', 'password', 'phone','gender',
        'age', 'zip_code', 'diet', 'becoins', 'saved_prom'
    ],
    db_shops:[
        '_id', 'shopname','description','web', 'timetable',  'photo',
        'location','address','district','neighbourhood','type','product_list'
    ],
    db_transactions:[
        '_id','shop_id','user_id','timestamp',
        'promotion_used','payment','becoins_gained'
    ],
    db_promotions:[
        '_id','shop_id','description','becoins','valid_interval'
    ],
    db_active_promotions:[
        '_id', 'prom_id', 'user_id', 'valid_until'
    ]
}


def _attrs_in(attributes, collection):
    """
    Return if all attributes are well defined in the collection
    """
    return all([key in collection_attributes[collection] for key in attributes])

def _get(collection, attributes=None, **query):
    """
    Base function for getters.

    Input:
        * `collection`: string, the name of the collection
        * `attributes`: the attributes to catch; `_id` is always given
        * `query`: conditions to search with.

    Output:
        * [{'attr':value, ...},...]: list of records that matches `query`.
    """

    if isinstance(attributes, str):
        attributes = [attributes]
    
    assert _attrs_in(attributes, collection) if attributes is not None else True
    assert _attrs_in(query.keys(), collection)
    
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, collection, query, operation)

    return list(response)

def getUser(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `users` has shape:
        `_id`, `username`, `email`, `password`, `phone`,
        `gender`, `age`, `zip_code`, `diet`, `becoins`, `saved_prom`.

    INPUT:
        * `attributes`: `list` of attributes to catch; all attributes are 
                        returned by default and `_id` is always implicit.
                        Can be also a single attribute in `str`.
        * `query`: conditions to search with. See examples below.

    OUTPUT:
        * [{'attr':value, ...},...]: list of records that matches `query`.

    EXAMPLES:
        >>> getUser()
        [...all users...]

        >>> getUser(age=20)
        [{all parameters user1}, {...}, ...]

        >>> getUser(['_id', 'email'], username='yikai')
        [{'_id': ObjectId('...'), 'email': '...'}]

        >>> getUser(['email'], age=20, gender='')
        [{'_id': OjectId(1..), 'email':...}, {'_id': OjectId(2..), email:...}, ...]

        >>> getUser('username', username='user1')
        [{'_id': ObjectId(...), 'username':'user1'}]

    For more information, see `tool.setUser` and database documentation.
    """
    return _get(db_users, attributes, **query)
    
def getShop(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `shops` has shape:
        `_id`, `shopname`, `description`, `timetable`,
        `photo`, `location`, `adress`, `type`, `product_list`, `phone`.

    For more information, see `tools.getUser`,`tools.setShop` and database documentation.
    """
    return _get(db_shops, attributes, **query)

def getPromotion(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `promotions` has shape:
        `_id`, `shop_id`, `description`, `becoins`, `valid_interval`

    For more information, see `tools.getUser`, `tools.setPromotion` and database documentation.
    """
    return _get(db_promotions, attributes, **query)

def getActivePromotion(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `promotions` has shape:
        `_id`, `prom_id`, `user_id`, `valid_until`

    For more information, see `tools.getUser` and database documentation.
    """
    return _get(db_active_promotions, attributes, **query)

def getTransaction(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `transactions` has shape:
        `_id`, `shop_id`, `user_id`, `timestamp`,
        `payment`, `becoin_gained`

    For more information, see `tools.getUser`, `tools.setTransaction` and database documentation.
    """
    return _get(db_transactions, attributes, **query)

def setUser(data):
    """
    Insert a record of user in the collection `users`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `username`:   str, unique
        * `email`:      str, unique
        * `password`:   str, encrypted
        * `phone`:      str, 9 digit
        * `gender`:     str, 'M' or 'F' (or 'O'->others?)
        * `age`:        int, positive
        * `zip_code`:   str, 5 digit
        * `diet`:       str
        * `becoins`:    float, positive

    OUTPUT:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    EXAMPLES:
        >>> setUser( {'username':'user1', 'email':'user1@mail.com', ..., 'becoins'=0} )
        (True, ObjectId(...))
        >>> setUser( {'username':'user1', 'email':'user1@mail.com', ..., 'becoins'=0} )

    See database documentation for more information.
    """

    if getUser(['_id'], username=data['username']):  # there is only one username per user
        return (False, None)
    if getUser(['_id'], email=data['email']):
        return (False, None)

    document = {
        'username': data["username"], 'email': data["email"], 'password': data["password"], 'phone': data["phone"],
        'gender': data["gender"], 'age': data["age"], 'zip_code': data["zip_code"], 'diet': data["diet"],
        'becoins': data["becoins"], "saved_prom" : data["saved_prom"]
    }
    response = db_handler.queryInsert(db_name, db_users, document, one=True)
    return response.acknowledged, response.inserted_id

def setShop(data):
    """
    Insert a record of shop in the collection `shops`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `shopname`:       str, unique?
        * `description`:    str
        * `timetable`:      {'Mo':[[h,m,h,m],[...]],'Tu':...,...}; 0<=h<=23, 0<=m<=59 int
        * `photo`:          str
        * `location`:       [float, float], longitude and latitude
        * `adress`:         str, adress of the shop
        * `type`:           str, 'Restaurant', 'FruitsAndVegetables', ...
        * `product_list`:   list of `product_id`
        * `phone`:          str, 9 digit

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    See database documentation for more information.
    """
    document = {
        'shopname': data["shopname"],  'description': data["description"], 'timetable': data["timetable"], 'web': data["web"],
        'photo': data["photo"], 'location': data["location"], 'adress':data["adress"], 'district': data["district"],
        'neighbourhood': data["neighbourhood"], 'type': data["type"], 'product_list': data["product_list"], 'phone': data["phone"]
    }
    response = db_handler.queryInsert(db_name, db_shops, document, one=True)
    return response.acknowledged, response.inserted_id

def setPromotion(data):
    """
    Insert a record of promotion in the collection `promotions`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `shop_id`:        ObjectId, should be in collection `shop`
        * `description`:    str
        * `becoins`:        int, positive
        * `valid_interval`: [float, float], timestamp

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    See database documentation for more information.
    """
    document = {
        'shop_id': data["shop_id"], 'description': data["description"],
        'becoins': data["becoins"], 'valid_interval': data["valid_interval"]
    }
    response = db_handler.queryInsert(db_name, db_promotions, document, one=True)
    return response.acknowledged, response.inserted_id

def setActivePromotion(data):
    """
    Insert a record of promotion in the collection `promotions`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `prom_id`:        ObjectId, should be in collection `promotions`
        * `user_id`:        ObjectId, should be in collection `users`
        * `valid_until`:    float, timestamp

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    See database documentation for more information.
    """
    document = {
        'prom_id': data["prom_id"], 'user_id': data["user_id"], 'valid_until': data["valid_until"]
    }
    response = db_handler.queryInsert(db_name, db_active_promotions, document, one=True)
    return response.acknowledged, response.inserted_id

def setTransaction(data):
    """
    Insert a record of promotion in the collection `promotions`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `shop_id`:        ObjectId, should be in collection `promotions`
        * `user_id`:        ObjectId, should be in collection `users`
        * `timestamp`:      float, timestamp
        * `promotion_used`: ObejctId, should be in collection `promotion`
        * `payment`:        float
        * `becoin_gained`:  float

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise
    """
    document = {
        'shop_id': data["shop_id"], 'user_id': data["user_id"], 'timestamp': data["timestamp"],
        'promotion_used': data["promotion_used"], 'payment': data["payment"], 'becoin_gained': data["becoin_gained"]
    }
    response = db_handler.queryInsert(db_name, db_transactions, document, one=True)
    return response.acknowledged, response.inserted_id

def _update(collection, _id, **updates):
    """
    Base function to update a single document with given `_id` and `collection`.
    Only resets values.

    INPUT:
        * `collection`: string, the name of the collection
        * `_id`: ObjectId of the document to update
        * `**setters`: values to set
    
    OUTPUT:
        * matches_count: the number of matched instances
        * modified_count: the number of modified instances.
        In a normal run, these values should be (1,1)
    """

    assert '_id' not in updates.keys()
    assert _attrs_in(updates.keys(), collection)

    query = {'_id':_id}
    operation = {'$set': updates}
    result = db_handler.queryUpdate(db_name, collection, query, operation, one=True)
    return result.matched_count, result.modified_count

def updateUser(_id, **updates):
    """
    Updates a single `user` given its `_id`.

    INPUT:
        * `_id`: ObjectId that identifies the user
        * `updates`: the values of the parameters to be set

    OUTPUT:
        * matches_count: the number of matched instances
        * modified_count: the number of modified instances.

    Examples:
        >>> updateUser(getUser()[0]['_id], username='newname')
        1,1
        >>> user1 = getUser()[0]
        >>> updateUser(user1['_id], becoins=user1['becoins']-100)
        1,1
        >>> updateUser(user1['_id'], _id=1)
        <assertionError>
    """

    ## this is O(number of users) !!!!!!!!!!!!!!!!!!!!
    if 'username' in updates:
        usernames = [user['username'] for user in getUser('username')]
        assert updates['username'] not in usernames
    if 'email' in updates:
        emails = [user['email'] for user in getUser('email')]
        assert updates['email'] not in emails

    return _update(db_users, _id, **updates)

def updateShop(_id, **updates):
    """
    See `updateUser()`.
    """
    return _update(db_shops, _id, **updates)

def updatePromotion(_id, **updates):
    """
    See `updateUser()`.
    """
    return _update(db_promotions, _id, **updates)

def updateActivePromotion(_id, **updates):
    """
    See `updateUser()`.
    """
    return _update(db_active_promotions, _id, **updates)

def updateTransaction(_id, **updates):
    """
    See `updateUser()`.
    """
    return _update(db_transactions, _id, **updates)


if __name__ == '__main__':
    # print('main')
    print(getUser())
    