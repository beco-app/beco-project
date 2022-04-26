"""
IMPLEMENTED:
    * Ensure that the names of the attributes are well-defined in getters.
    * Remove or update of records?

TO IMPLEMENT:
    * Check the business rules in setters
    * Getteres with query that supports >, <, <=, ...
    * Add a `limit` parameter to limit the size of the output of getters
        (the parameter is already in db_handler.py file)
"""

import sys
sys.path.append("./backend/data_base")

from site import getusersitepackages
import pymongo
# from bson.objectid import ObjectId
import db_handler # using relative path
import re
# import os
import json

# Globals
config = json.load(open("./backend/config/config.json"))
db_username = config["db_username"]
db_password = config["db_password"]
db_name = config["db_name"]
db_users = config["db_users"]
db_shops = config["db_shops"]
db_transactions = config["db_transactions"]
db_promotions = config["db_promotions"]
db_active_promotions = config["db_active_promotions"]
db_products = config["db_products"]


## if there is any change in attributes, then change:
##   * collection_attributes list
##   * Documentation of get, set, update, remove...
##   * 

collection_attributes = {
    db_users: [
        '_id','username','email', 'password', 'phone','gender',
        'birthday', 'zip_code', 'preferences', 'becoins', 'saved_prom'
    ],
    db_shops:[
        '_id', 'shopname','description','web', 'timetable',  'photo',
        'location','address','district','neighbourhood','type','product_list', 
        'zip_code', 'nearest_stations', 'tags'
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
    
    if (attributes is not None and not _attrs_in(attributes, collection)) or \
        (not _attrs_in(query.keys(), collection)):
        raise Exception(f"Wrong attribute name for collection '{collection}'.")
    
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, collection, query, operation)

    return list(response)

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

    if '_id' in updates.keys():
        raise Exception("Update of internal `_id` is forbidden.")

    if not _attrs_in(updates.keys(), collection):
        raise Exception(f"Wrong attribute name for collection '{collection}'.")

    query = {'_id':_id}
    operation = {'$set': updates}
    result = db_handler.queryUpdate(db_name, collection, query, operation, one=True)
    return result.matched_count, result.modified_count


def getUser(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `users` has shape:
        `_id`, `username`, `email`, `password`, `phone`,
        `gender`, `birthday`, `zip_code`, `diet`, `becoins`, `saved_prom`.

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

        >>> getUser(zip_code='08018')
        [{all parameters user1}, {...}, ...]

        >>> getUser(['_id', 'email'], username='yikai')
        [{'_id': ObjectId('...'), 'email': '...'}]

        >>> getUser(['email'], zip_code='08018', gender='F')
        [{'_id': OjectId(1..), 'email':...}, {'_id': OjectId(1..), email:...}, ...]

        >>> getUser('username', username='user1')
        [{'_id': ObjectId(...), 'username':'user1'}]

    For more information, see `tool.setUser` and database documentation.
    """
    return _get(db_users, attributes, **query)
    
def getShop(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `shops` has shape:
        `_id`, `shopname`, `description`, `timetable`, 'zip_code'
        `photo`, `location`, `address`, `type`, `product_list`, `phone`.

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
        * `birthday`:   float, timestamp
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
        'gender': data["gender"], 'birthday': data["birthday"], 'zip_code': data["zip_code"], 'preferences': data["preferences"],
        'becoins': data["becoins"], "saved_prom" : data["saved_prom"]
    }
    response = db_handler.queryInsert(db_name, db_users, document, one=True)
    return response.acknowledged, response.inserted_id

def setShop(data):
    """
    Insert a record of shop in the collection `shops`.

    A single dictionary is given.
    The attribute `_id` cannot be manually set.

    INPUT:
        The dictionary `data` should have the following:
        * '_id':		    ObjectId
        * 'shopname':	    str
        * 'description':    str
        * 'web': 	        str
        * 'timetable':	    {weekday:[]}
        * 'photo':	        str
        * 'location': 	    [lat, lon]
        * 'address':	    str
        * 'district':	    str
        * 'neighbourhood':  str
        * 'type':	        str
        * 'product_list':   [product_id]
        * 'phone':          str, 9 digits
        * 'zip_code':       str, 5 digits
        * 'tags':           [str, str, str]

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    See database documentation for more information.
    """
    document = {
        'shopname': data["shopname"],   'description':  data["description"],  'timetable':        data["timetable"], 
        'web':      data["web"],        'photo':        data["photo"],        'location':         data["location"], 
        'address':  data["address"],    'district':     data["district"],     'neighbourhood':    data["neighbourhood"], 
        'zip_code': data["zip_code"],   'type':         data["type"],         'tags':             data["tags"],
        'phone':    data["phone"],      'product_list': data["product_list"], 'nearest_stations': data['nearest_stations']
        
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
        * `valid_interval`: {'from': float, 'to': float}, timestamp

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
        Exception: Update of internal _id is forbidden.
    """

    ## this is O(number of users) !!!!!!!!!!!!!!!!!!!!
    if 'username' in updates:
        if len(getUser(username=updates['username'])):
            raise Exception("The username already exists.")
    if 'email' in updates:
        if len(getUser(email=updates['email'])):
            raise Exception("The email is already used.")

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


def removeActivePromotion(_id):
    """
    Due to the characteristics of the active promotion,
    the remove operation will be necessary.

    Only accepts one single _id.

    Return the number of removed promotions. 
    Should be 1 in case of match as _id should be unique.
    """
    res = db_handler.queryRemove(db_name, db_active_promotions, {'_id':_id}, one=True)
    return res.deleted_count

if __name__ == '__main__':
    print('main')
    print(getUser()[0])
    
