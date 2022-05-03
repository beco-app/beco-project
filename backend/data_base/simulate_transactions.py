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
        softmax_shop = softmax_ntrans[shop["_id"]]
        _, fd, lz, pk = u_latent.values()

        score = (np.exp(-lz*dist)  +  pk * common_tags / 3  +  fd * softmax_shop ) / 3
        scores[shop["_id"]] = score

    return scores

def addLocation(user, geolocator):
    resp = user.copy()
    loc_obj = geolocator.geocode({"country": "Spain", "postalcode": user["zip_code"]})
    resp["location"] = [loc_obj.latitude, loc_obj.longitude]
    return resp

def transaction_gen(n_days):
    now = time()

    geolocator = Nominatim(user_agent="beco")
    all_users = getUser()
    all_users = {user["_id"]: addLocation(user, geolocator) for user in all_users}

    all_shops = getShop()
    all_shops = {shop["_id"]: shop for shop in all_shops}
    transactions = {uid: [] for uid in all_users.keys()}

    latent = {}
    for uid in all_users.keys():
        freq = random.random()
        fidelity = random.random()
        laziness = random.random()
        pickiness = random.random()
        latent[uid] = {"freq": freq, "fidelity": fidelity, "laziness": laziness, "pickiness": pickiness}

    days = range(n_days, 0, -1)
    for day in days:
        buying_users = []
        for uid in all_users.keys():
            buys = np.random.binomial(n=1, p=latent[uid]["freq"])
            if buys: buying_users.append(uid)

        for uid in buying_users:
            # score for each shop and set record
            scores = computeScores(all_shops=all_shops, user=all_users[uid], u_transactions=transactions[uid], u_latent=latent[uid]) # dict(shop_id: score)
            shop_chosen = random.choices(scores.keys(), weights=scores.values(), k=1)[0]

            timestamp = random.uniform(now - day * 3600 * 24, now - (day - 1) * 3600 * 24)
            promotion_used = None
            payment = round(random.uniform(5, 60), 2)
            becoin_gained = payment // 10 * 100

            record = {'shop_id': shop_chosen, 'user_id': uid, 'timestamp': timestamp,
             'promotion_used': promotion_used, 'payment': payment, 'becoin_gained': becoin_gained}

            print(f"record for uid: {uid}, day:{day} ---> {record}")
            transactions[uid].append(shop_chosen)

    print(transactions)


if __name__ == '__main__':
    transaction_gen(n_days=1)

