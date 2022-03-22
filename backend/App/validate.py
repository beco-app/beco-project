from functools import wraps
from flask import request, abort
from bson.objectid import ObjectId
import sys
sys.path.append("./backend/data_base")
import tools
from time import time

def validate_promotion(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        promotion_id = request.form.get('promotion_id')
        user_id = request.form.get('user_id')
        promotions = tools.getPromotion(_id = ObjectId(promotion_id))
        users = tools.getUser(_id = ObjectId(user_id))
        assert len(promotions) == 1 and len(users) == 1
        promotion = promotions[0]
        user = users[0]
        now = time()
        assert promotion['valid_interval'][0] < now < promotion['valid_interval'][1]
        assert promotion['becoins'] <= user['becoins']
        return f(*args, **kwargs) 
    return wrapper


@validate_promotion
def foo(a, b, **attr):
    return a, b, attr

foo(1,2,name='tomas')