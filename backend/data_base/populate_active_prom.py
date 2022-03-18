from tools import *
import random
import time

# {
#   _id:		 ObjectId
#   prom_id:	 ObjectId
#   user_id:	 ObjectId
#   valid_until:float>0
# }


def active_prom_gen(n):
    """
    Generator of n active promotions
    """
    print( getUser(['_id'])[0] )
    prom_ids = [ p['_id'] for p in random.choices(getPromotion(['_id']), k=n) ]
    user_ids = [ u['_id'] for u in random.choices(getUser(['_id']), k=n) ]
    for prom_id, user_id in  zip(prom_ids, user_ids):
        active_prom = {
            'prom_id': prom_id, 
            'user_id':user_id, 
            'valid_until': time.time() + 7*24*60*60 # 1 week
        }
        yield active_prom


def populate_active_prom(n):
    active_proms = active_prom_gen(n)
    for ap in active_proms:
        print(setActivePromotion(ap))

if __name__ == '__main__':
    populate_active_prom(10)
