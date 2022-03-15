"""
TO IMPLEMENT:
    * Remove or update of records?
    * Ensure that the names of the attributes are well-defined in getters
    * Check the business rules in setters
    * Getteres with query that supports >, <, <=, ...
    * Add a `limit` parameter to limit the size of the output of getters
        (the parameter is already in db_handler.py file)
"""

from site import getusersitepackages
import pymongo
from bson.objectid import ObjectId
import db_handler
import re
# import os
import json

# Globals
config = json.load(open("../config/config.json"))
db_username = config["db_username"]
db_password = config["db_password"]
db_name = config["db_name"]
db_users = config["db_users"]
db_shops = config["db_shops"]
db_transactions = config["db_transactions"]
db_promotions = config["db_promotions"]
db_active_promotions = config["db_active_promotions"]
db_products = config["db_products"]


# Setters and Getters

# def getUserIdByUserName(user_name):
#     query = {"username": {"$eq": user_name}}
#     operation = {"_id": 1}
#     response = db_handler.queryFind(db_name, db_users, query, operation=operation, one=True)

#     return response

# def getAllRecords(collection):
#     query = {}
#     response = db_handler.queryFind(db_name, collection, query)
#     return list(response)


def getUser(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `users` has shape:
        `_id`, `username`, `email`, `password`, `phone`,
        `gender`, `age`, `zip_code`, `diet`, `becoins`.

    INPUT:
        * `attributes`: attributes to catch; all attributes are returned by default
                        and `_id` is always implicit.
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

    For more information, see `tool.setUser` and database documentation.
    """
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_users, query, operation)
    return list(response)


def getShop(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `shops` has shape:
        `_id`, `shopname`, `description`, `timetable`,
        `photo`, `location`, `adress`, `type`, `product_list`, `phone`.

    For more information, see `tools.getUser`,`tools.setShop` and database documentation.
    """
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_shops, query, operation)
    return list(response)


def getPromotion(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `promotions` has shape:
        `_id`, `shop_id`, `description`, `becoins`, `valid_interval`

    For more information, see `tools.getUser`, `tools.setPromotion` and database documentation.
    """
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_promotions, query, operation)
    return list(response)


def getActivePromotion(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `promotions` has shape:
        `_id`, `prom_id`, `user_id`, `valid_until`

    For more information, see `tools.getUser` and database documentation.
    """
    operation = dict([(attr, True) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_active_promotions, query, operation)
    return list(response)


def getTransaction(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Each of the record from `transactions` has shape:
        `_id`, `shop_id`, `user_id`, `timestamp`,
        `payment`, `becoin_gained`

    For more information, see `tools.getUser`, `tools.setTransaction` and database documentation.
    """
    operation = dict([(attr, 1) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_transactions, query, operation)
    return list(response)


def setUser(data):
    """
    Insert a record of user in the collection `users`.

    The arguments are wrote explicitely in the function to avoid typos when inserting.
    The attribute `_id` cannot be manually set.

    INPUT:
        * `username`:   str, unique?
        * `email`:      str
        * `password`:   str, encrypted
        * `phone`:      str, 9 digit
        * `gender`:     str, 'M' or 'F' (or 'O'->others?)
        * `age`:        int, positive
        * `zip_code`:   str, 5 digit
        * `diet`:       str
        * `becoins`:    float, positive

    Returns:
        * (True, ObjectId) if the insertion succeed
        * (False, None) otherwise

    See database documentation for more information.
    """

    if getUser(['_id'], username=data['username']):  # there is only one username per user
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
        'shopname': data["shopname"], 'description': data["description"], 'timetable': data["timetable"],
        'photo': data["photo"], 'location': data["location"], 'adress': data["adress"], 'type': data["type"],
        'product_list': data["product_list"], 'phone': data["phone"]
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
        'timetable': data["timetable"], 'valid_interval': data["valid_interval"]
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


if __name__ == '__main__':
    # print('main')
    print(getUser())
    # print(setShop('Perruqueria Casas', '404', '', '', [40.3879, 2.16992], 'Barber', [], '600100290'))
