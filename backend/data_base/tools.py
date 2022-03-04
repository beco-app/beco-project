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


db_handler.hello()


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
    Examples:

        > getUser(age=20)
        [{all parameters user1}, {...}, ...]

        > getUser(['_id', 'email'], username='yikai')
        [{'_id': ObjectId('...'), 'email': 'yikai.qiu@upc.edu'}]

        > getUser(['_id'], age=20)
        [{'_id', OjectId(1..)}, {'_id', OjectId(2..)}, ...]

    To implement:
        * Ensure that the names of the parameters are well-defined
        * Add a `limit` parameter to limit the size of the output 
            (the parameter is already in db_handler.py file)
    """
    operation = dict([(attr,1) for attr in attributes]) if attributes is not None else None
    response = db_handler.queryFind(db_name, db_users, query, operation)
    return list(response)

print(getUser(age=20))


def getShop(id): 
    """
    gets the shop as a dictionary from the id of type ObjectId
    """
    pass


def getPromotion(id): 
    """
    gets the promotion as a dictionary from the id of type ObjectId
    """
    pass

def getActive_Promotion(id): 
    """
    gets the active promotion as a dictionary from the id of type ObjectId
    """
    pass


def setUser(username, email, password, phone, gender, age, zip_code, diet, becoins): 
    """
    inserts a user in the table users.
    """
    # db_handler.queryInsert(db_name, db_users)
    pass


def setShop(): 
    """
    inserts a shop in shops
    """
    pass


def setPromotion(): 
    """
    inserts a promotion in the table promotion
    """
    pass


def setActive_Promotion(): 
    """
    inserts an active promotion in the table active_promotion
    """
    pass

