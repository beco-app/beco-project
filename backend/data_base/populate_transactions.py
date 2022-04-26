from tools import *
import random
from time import time
import numpy as np

# Each transaction has:
# shop_id
# user_id
# timestamp
# promotion_used (optional)
# payment
# becoins_gained

def transaction_gen(n):
    all_users = getUser()
    all_shops = getShop()
    user_ids = [u['_id'] for u in all_users]
    shop_ids = [s['_id'] for s in all_shops]
    users = random.choices(user_ids, k=5*n)
    shops = random.choices(shop_ids, k=5*n)
    # Random timestamps from the last month
    now = time()
    times = np.sort([random.uniform(now-3600*24*30, now) for i in range(n)])
    proms = [None] * n  # TODO when promotions populated
    pays = [round(random.uniform(5, 60), 2) for i in range(n)]
    # 100 becoins for each 10€ spent
    becoins = [p//10*100 for p in pays]
    return zip(users, shops, times, proms, pays, becoins)


def populate_transactions(n):
    transactions = transaction_gen(n)
    for t in transactions:
        t = {'shop_id': t[0], 'user_id': t[1], 'timestamp': t[2],
             'promotion_used': t[3], 'payment': t[4], 'becoin_gained': t[5]}
        print(setTransaction(t))

if __name__ == '__main__':
    populate_transactions(5000)
        
