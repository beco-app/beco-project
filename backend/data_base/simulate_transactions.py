from tools import *
import random
from time import time
import numpy as np
from geopy.distance import distance
from collections import Counter
from tqdm import tqdm

def computeScores(all_shops, user, u_transactions, u_latent):
    n_transactions = Counter(u_transactions)
    ntrans_exp = np.exp(list(n_transactions.values()))
    softmax_list = ntrans_exp / sum(ntrans_exp)
    softmax_ntrans = dict(zip(n_transactions.keys(), softmax_list))
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
    return scores


def transaction_gen(n_days, hard=False, n_hard=None):
    now = time()

    all_users = getUser() # all users from db with all fields
    all_users = {user["_id"]: user for user in all_users} # index users by id

    all_shops = getShop() # all shops from db with all fields
    all_shops = {shop["_id"]: shop for shop in all_shops} # index shops by id

    transactions = {uid: [] for uid in all_users.keys()} # init empty lists of shop_ids for each user indexed by user_id

    # generate random latent vars for each user (uniform random [0,1])
    latent = {}
    for uid in (t:=tqdm(all_users.keys())):
        t.set_description("generating latent")
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

        for uid in buying_users:
            # compute score for each shop and then set record
            scores = computeScores(all_shops=all_shops, user=all_users[uid], u_transactions=transactions[uid], u_latent=latent[uid]) # dict(shop_id: score)
            if hard and n_hard is not None:
                sorted_shops = dict(sorted(scores.items(), key=lambda item: item[1], reverse=True))
                shop_chosen = random.choices(list(sorted_shops.keys())[:n_hard], weights=list(sorted_shops.values())[:n_hard], k=1)[0]  # shop_id
            else:
                shop_chosen = random.choices(list(scores.keys()), weights=scores.values(), k=1)[0]  # shop_id

            # NOTE: try to limit the timestamps to the shop opening interval (avoid smth like transactions at 3am xd)
            timestamp = random.uniform(now - day * 3600 * 24, now - (day - 1) * 3600 * 24)
            promotion_used = None
            payment = round(random.uniform(5, 60), 2)
            becoin_gained = payment // 10 * 100

            record = {'shop_id': shop_chosen, 'user_id': uid, 'timestamp': timestamp,
             'promotion_used': promotion_used, 'payment': payment, 'becoin_gained': becoin_gained}

            print(setTransaction(record))
            transactions[uid].append(shop_chosen)

    total_trans = 0
    for k,v in transactions.items():
        total_trans += len(v)

    print(f"total transactions {total_trans}")


if __name__ == '__main__':
    print("computing transactions")
    transaction_gen(n_days=10, hard=True, n_hard=5)

