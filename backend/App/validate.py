from functools import wraps
from flask import request, abort
from bson.objectid import ObjectId
from time import time
import sys
import os

sys.path.append(os.getcwd())
from backend.data_base import tools


def validate_user_exists(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        # user_id = request.form.get('user_id')
        data = request.form.to_dict()
        users = None
        if "user_id" in data.keys():
            user_id = data['user_id']
            users = tools.getUser(_id = ObjectId(user_id))
        elif "username" in data.keys():
            username = data['username']
            users = tools.getUser(username=username)
        if not users: abort(401)
        return f(*args, **kwargs) 
    return wrapper
        


def validate_promotion(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        promotion_id = request.form.get('promotion_id')
        user_id = request.form.get('user_id')
        promotions = tools.getPromotion(_id = ObjectId(promotion_id))
        users = tools.getUser(_id = ObjectId(user_id))

        if len(promotions) != 1 or len(users) != 1: abort(400)
        promotion = promotions[0]
        user = users[0]

        # Check if the promotion is valid
        now = time()
        if now <= promotion['valid_interval']['from'] or promotion['valid_interval']['to'] <= now: abort(400)

        # Check if user has enough becoins
        if user['becoins'] < promotion['becoins']: abort(400)
        return f(*args, **kwargs) 
    return wrapper

def validate_user(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        promotion_id = request.form.get('promotion_id')
        user_id = request.form.get('user_id')
        promotions = tools.getPromotion(_id = ObjectId(promotion_id))
        users = tools.getUser(_id = ObjectId(user_id))
        #assert len(promotions) == 1 and len(users) == 1
        if len(promotions) != 1 or len(users) != 1: abort(400)
        promotion = promotions[0]
        user = users[0]
        now = time()
        #assert promotion['valid_interval']['from'] < now < promotion['valid_interval']['to']
        if now <= promotion['valid_interval']['from'] or promotion['valid_interval']['to'] <= now: abort(400)
        #assert promotion['becoins'] <= user['becoins']
        if user['becoins'] < promotion['becoins']: abort(400)
        return f(*args, **kwargs) 
    return wrapper


def validate_unique_username(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        username = request.form.get('email')
        user_exists = tools.getUser(username=username) # empty list if new user
        print("user_exists", user_exists)
        if user_exists: abort(400)
        return f(*args, **kwargs)
    return wrapper



# @validate_promotion
# def foo(a, b, **attr):
#     return a, b, attr

# foo(1,2,name='tomas')
