import pymongo
from bson.objectid import ObjectId
import db_handler
import re
#import os
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

def getUserIdByUserName(user_name):
    query = {"username": {"$eq": user_name}}
    operation = {"_id": 1}
    response = db_handler.queryFind(db_name, db_users, query, operation=operation, one=True)

    return response

def getAllRecords(collection):
    query = {}
    response = db_handler.queryFind(db_name, collection, query)
    return list(response)


def getUser(attributes=None, **query):
    """
    Return a list of records with `attributes` based on `query`.
    Always returns '_id' if possible.
    Examples:
        >>> getUser()
        [...all users...]

        >>> getUser(age=20)
        [{all parameters user1}, {...}, ...]

        >>> getUser(['_id', 'email'], username='yikai')
        [{'_id': ObjectId('...'), 'email': 'yikai.qiu@upc.edu'}]

        >>> getUser(['email'], age=20)
        [{'_id': OjectId(1..), 'email':...}, {'_id': OjectId(2..), emial:...}, ...]

    To implement:
        * Ensure that the names of the parameters are well-defined
        * Multifunctional query that supports as >, <, <=, ...
        * Add a `limit` parameter to limit the size of the output
            (the parameter is already in db_handler.py file)
    """
    operation = dict([(attr,1) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_users, query, operation)
    return list(response)


def getShop(attributes=None, **query):
    """
    Each record of shop has the following attributes:
        shopname, description, timetable, photo, location, type, product_list, phone
    Return a list of records with `attributes` based on `query`.
    Examples (see `tools.getUser()`)
    To implement:
        * Ensure that the names of the parameters are well-defined
        * Multifunctional query that supports as >, <, <=, ...
        * Add a `limit` parameter to limit the size of the output
            (the parameter is already in db_handler.py file)
    """
    operation = dict([(attr,1) for attr in attributes]) if attributes is not None else None
    response  = db_handler.queryFind(db_name, db_shops, query, operation)
    return list(response)


def getPromotion(attributes=None, **query): 
    """
    """
    operation = dict([(attr,1) for attr in attributes]) if attributes is not None else None
    response  = db_handler.queryFind(db_name, db_promotions, query, operation)
    return list(response)

def getActivePromotion(attributes=None, **query): 
    """
    gets the active promotion as a dictionary from the id of type ObjectId
    """
    operation = dict([(attr,1) for attr in attributes]) if attributes is not None else None
    response  = db_handler.queryFind(db_name, db_active_promotions, query, operation)
    return list(response)
    pass


def setUser(username, email, password, phone, gender, age, zip_code, diet, becoins): 
    """
    Insert a user in the collection users.
    The arguments are wrote explicitely in the function to avoid typos in the fields.
    The attribute `_id` cannot be manually set.
    
    Returns: a tuple 
        - (True, ObjectId) if the insertion succeed
        - (False, None) otherwise
    """

    if getUser(['_id'], username=username): # there is only one username per user
        return (False, None)

    document = {
        'username': username,  'email': email, 'password': password, 'phone': phone, 
        'gender'  : gender,      'age': age,   'zip_code': zip_code, 'diet' : diet, 
        'becoins' : becoins
    }
    response = db_handler.queryInsert(db_name, db_users, document, one=True)
    return response.acknowledged, response.inserted_id


def setShop(shopname, description, timetable, photo, location, _type, product_list, phone): 
    """
    inserts a shop in shops
    """
    
    document = {
        'shopname': shopname,  'description': description, 'timetable': timetable,    'photo': photo, 
        'location': location,         'type': _type,    'product_list': product_list, 'phone': phone
    }
    response = db_handler.queryInsert(db_name, db_shops, document, one=True)
    return response.acknowledged, response.inserted_id


def setPromotion(shopid, description, becoins, valid_interval): 
    """
    inserts a promotion in the table promotion
    """
    document = {
        'shopid'   : shopid,  'description'   : description, 
        'timetable': becoins, 'valid_interval': valid_interval
    }
    response = db_handler.queryInsert(db_name, db_promotions, document, one=True)
    return response.acknowledged, response.inserted_id


def setActivePromotion(prom_id, user_id, valid_until): 
    """
    inserts an active promotion in the table active_promotion
    """
    document = {
        'prom_id': prom_id,  'user_id': user_id, 'valid_until': valid_until
    }
    response = db_handler.queryInsert(db_name, db_active_promotions, document, one=True)
    return response.acknowledged, response.inserted_id

if __name__ == '__main__':
    # print('main')
    print(getShop())
    # print(setShop('Perruqueria Casas', '404', '', '', [40.3879, 2.16992], 'Barber', [], '600100290'))