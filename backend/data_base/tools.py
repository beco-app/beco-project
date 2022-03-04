import pymongo
from bson.objectid import ObjectId
import db_handler as db_handler
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

print(getUserIdByUserName('yikai'))
print(getAllRecords(db_users))

def getUser(id):
    """gets the user as a dictionary from the id of type ObjectId"""
    pass


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


def setUser(): 
    """
    inserts a user in the table users.
    """
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

