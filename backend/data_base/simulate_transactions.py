from tools import *
import random
from time import time
import numpy as np
from geopy.distance import distance
from geopy.geocoders import Nominatim
from collections import Counter


# Each transaction has:
# shop_id
# user_id
# timestamp
# promotion_used (optional)
# payment
# becoins_gained

def computeScores(all_shops, user, u_transactions, u_latent):
    n_transactions = Counter(u_transactions)
    ntrans_exp = np.exp(list(n_transactions.values()))
    softmax_list = ntrans_exp / sum(ntrans_exp)
    softmax_ntrans = dict(zip(n_transactions.keys(), softmax_list))
    
    scores = {}
    for shop in all_shops.values():
        dist = distance(shop["location"], user["location"]).km
        common_tags = len(set(shop["tags"]).intersection(set(user["preferences"])))
        softmax_shop = softmax_ntrans[shop["_id"]] if shop["_id"] in softmax_ntrans.keys() else 0
        _, fd, lz, pk = u_latent.values()

        score = (np.exp(-lz*dist)  +  pk * common_tags / 3  +  fd * softmax_shop ) / 3
        scores[shop["_id"]] = score

    return scores

def addLocation(user, geolocator, locs):
    """
    Args:
        user: dict conatining user0s info from db
        geolocator:

    Returns: the user dict with location field [lat, long]
    """
    resp = user.copy()
    if user["zip_code"] not in locs:
        loc_obj = geolocator.geocode({"country": "Spain", "postalcode": user["zip_code"]})
        print(f"loc_obj: {loc_obj}")
        try:
            locs[user["zip_code"]] = [loc_obj.latitude, loc_obj.longitude]
        except:
            print(f"lat,long not found for zipcode: {user['zip_code']}")
    resp["location"] = locs[user["zip_code"]]
    return resp

def transaction_gen(n_days):
    now = time()

    geolocator = Nominatim(user_agent="beco")
    all_users = getUser() # all users from db with all fields
    locs = {}
    all_users = {user["_id"]: addLocation(user, geolocator, locs) for user in all_users} # index users by id and add location field

    all_shops = getShop() # all shops from db with all fields
    all_shops = {shop["_id"]: shop for shop in all_shops} # index shops by id
    transactions = {uid: [] for uid in all_users.keys()} # init empty lists of shop_ids for each user indexed by user_id

    # generate random latent vars for each user (uniform random [0,1])
    latent = {}
    for uid in all_users.keys():
        freq = random.random()
        fidelity = random.random()
        laziness = random.random()
        pickiness = random.random()
        latent[uid] = {"freq": freq, "fidelity": fidelity, "laziness": laziness, "pickiness": pickiness}

    # days from previous n_days until yesterday (n_days,...,3,2,1)
    days = range(n_days, 0, -1)
    for day in days:
        # decide which users are going to buy that day
        buying_users = []
        for uid in all_users.keys():
            buys = np.random.binomial(n=1, p=latent[uid]["freq"])
            if buys: buying_users.append(uid)

        print(len(buying_users))
        for uid in buying_users:
            # compute score for each shop and then set record
            scores = computeScores(all_shops=all_shops, user=all_users[uid], u_transactions=transactions[uid], u_latent=latent[uid]) # dict(shop_id: score)
            shop_chosen = random.choices(list(scores.keys()), weights=scores.values(), k=1)[0] # shop_id

            # NOTE: try to limit the timestamps to the shop opening interval (avoid smth like transactions at 3am xd)
            timestamp = random.uniform(now - day * 3600 * 24, now - (day - 1) * 3600 * 24)
            promotion_used = None
            payment = round(random.uniform(5, 60), 2)
            becoin_gained = payment // 10 * 100

            record = {'shop_id': shop_chosen, 'user_id': uid, 'timestamp': timestamp,
             'promotion_used': promotion_used, 'payment': payment, 'becoin_gained': becoin_gained}

            #print(f"record for uid: {uid}, day:{day} ---> {record}")
            transactions[uid].append(shop_chosen)

    #print(transactions)


if __name__ == '__main__':
    print("computing transactions")
    transaction_gen(n_days=10)

