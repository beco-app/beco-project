from functools import wraps
from flask import request, abort
from bson.objectid import ObjectId
from time import time
import sys
local = True
if local:
    sys.path.append("/Users/tomas.gadea/tomasgadea/ACADEMIC/GCED/q6/PE/beco/beco-project")
    from backend.data_base import tools
else:
    from data_base import tools


def validate_user_exists(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        #user_id = request.form.get('user_id')
        data = request.form.to_dict()
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
        #assert len(promotions) == 1 and len(users) == 1
        if len(promotions) != 1 or len(users) != 1: abort(400)
        promotion = promotions[0]
        user = users[0]
        now = time()
        #assert promotion['valid_interval'][0] < now < promotion['valid_interval'][1]
        if now <= promotion['valid_interval'][0] or promotion['valid_interval'][1] <= now: abort(400)
        #assert promotion['becoins'] <= user['becoins']
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
        #assert promotion['valid_interval'][0] < now < promotion['valid_interval'][1]
        if now <= promotion['valid_interval'][0] or promotion['valid_interval'][1] <= now: abort(400)
        #assert promotion['becoins'] <= user['becoins']
        if user['becoins'] < promotion['becoins']: abort(400)
        return f(*args, **kwargs) 
    return wrapper


def validate_unique_username(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        username = request.form.get('username')
        current_usernames = [info_dict['username'] for info_dict in tools.getUser(["username"])]
        user_exists = tools.getUser(username=username) # empty list if new user
        if user_exists: abort(400)
        return f(*args, **kwargs)
    return wrapper



# @validate_promotion
# def foo(a, b, **attr):
#     return a, b, attr

# foo(1,2,name='tomas')