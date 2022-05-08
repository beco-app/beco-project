from tools import *
import random
from time import time
import numpy as np
from geopy.distance import distance
from geopy.geocoders import Nominatim
from collections import Counter
from tqdm import tqdm


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
    #print(f"\n\n{user['preferences']}, {len(user['preferences'])}")
    intersects = []
    scores = {}
    for shop in all_shops.values():
        dist = distance(shop["location"], user["location"]).km
        u_pref = [pref.lower() for pref in user["preferences"]]
        sh_tags = [tag.lower() for tag in shop["tags"]]
        common_tags = len(set(sh_tags).intersection(set(u_pref)))
        softmax_shop = softmax_ntrans[shop["_id"]] if shop["_id"] in softmax_ntrans.keys() else 0
        _, fd, lz, pk = u_latent.values()

        score = (np.exp(-lz*dist)  +  pk * common_tags / 3  +  fd * softmax_shop ) / 3
        scores[shop["_id"]] = score**4

        intersects.append(common_tags)

    #print(f"max(intersects): {max(intersects)}")
    return scores


def transaction_gen(n_days, hard=False, n_hard=None):
    now = time()

    all_users = getUser() # all users from db with all fields
    locs = {}
    all_users = {user["_id"]: user for user in all_users}

    all_shops = getShop() # all shops from db with all fields
    all_shops = {shop["_id"]: shop for shop in all_shops} # index shops by id
    transactions = {uid: [] for uid in all_users.keys()} # init empty lists of shop_ids for each user indexed by user_id

    dists = {}

    # generate random latent vars for each user (uniform random [0,1])
    latent = {}
    for uid in all_users.keys():
        u_dists = {shop: distance(all_shops[shop]['location'], all_users[uid]['location']).km for shop in all_shops.keys()}
        dists[uid] = u_dists

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

        #print(f"number of buying users for day {day}: {len(buying_users)}")
        iii = 0
        for uid in buying_users:
            # compute score for each shop and then set record
            scores = computeScores(all_shops=all_shops, user=all_users[uid], u_transactions=transactions[uid], u_latent=latent[uid]) # dict(shop_id: score)
            #print(f"\n\n latent of {uid}: {latent[uid]}")
            #print(f"scores of uid: {uid} --> {sorted(scores.values(), reverse=True)[:5]}")
            #for sh,sc in list(dict(sorted(scores.items(), key=lambda item: item[1], reverse=True)).items())[:5]:
            #    print(f"shop: {sh}, score: {sc}, distance: {distance(all_shops[sh]['location'], all_users[uid]['location']).km}")

            #print(f"min(dist): {min(dists[uid].values())}  max(dist):  {max(dists[uid].values())}")
            if hard and n_hard is not None:
                sorted_shops = dict(sorted(scores.items(), key=lambda item: item[1], reverse=True))
                shop_chosen = random.choices(list(sorted_shops.keys())[:n_hard], weights=list(sorted_shops.values())[:n_hard], k=1)[0]  # shop_id
            else:
                shop_chosen = random.choices(list(scores.keys()), weights=scores.values(), k=1)[0]  # shop_id




            u_pref = [pref.lower() for pref in all_users[uid]["preferences"]]
            sh_tags = [tag.lower() for tag in all_shops[shop_chosen]["tags"]]
            common_tags = set(sh_tags).intersection(set(u_pref))

            #print(f"user: {uid}\n u_loc: {all_users[uid]['location']}\n shop chosen: {shop_chosen}\n loc: {all_shops[shop_chosen]['location']}\n hood: {all_shops[shop_chosen]['neighbourhood']}\n type: {all_shops[shop_chosen]['type']}\n tags: {all_shops[shop_chosen]['tags']}\n distance: {dists[uid][shop_chosen]}\n intersect: {common_tags}, {len(common_tags)}")
            #if len(common_tags) > 2:
            #    print(uid, shop_chosen, common_tags, len(common_tags))
            #import matplotlib.pyplot as plt
            #plt.plot(range(len(scores.values())), sorted(scores.values(), reverse=True))
            #plt.show()

            # NOTE: try to limit the timestamps to the shop opening interval (avoid smth like transactions at 3am xd)
            timestamp = random.uniform(now - day * 3600 * 24, now - (day - 1) * 3600 * 24)
            promotion_used = None
            payment = round(random.uniform(5, 60), 2)
            becoin_gained = payment // 10 * 100

            record = {'shop_id': shop_chosen, 'user_id': uid, 'timestamp': timestamp,
             'promotion_used': promotion_used, 'payment': payment, 'becoin_gained': becoin_gained}

            #print(f"record for uid: {uid}, day:{day} ---> {record}")
            transactions[uid].append(shop_chosen)


            iii += 1
            if iii > 10:
                pass
                #break

    total_trans = 0
    for k,v in transactions.items():
        print(k, len(v))
        print()
        total_trans += len(v)

    print(f"total transactions {total_trans}")


if __name__ == '__main__':
    print("computing transactions")
    transaction_gen(n_days=10, hard=True, n_hard=5)

