import sys

sys.path.append("./backend/data_base")
from tools import *
from collections import Counter
from geopy.distance import distance
import numpy as np
from bson.objectid import ObjectId
from time import time
import random


def get_shop_count(uid, all_trans):
    """
    Return all shops where uid has buyed and how many times (normalized)
    Return in a dict {shop_id: normalized_times}
    """
    all_shops = [t['shop_id'] for t in all_trans if t['user_id'] == uid]
    count_shops = Counter(all_shops)
    norm = sum([v ** 2 for v in count_shops.values()])
    norm_shops = {k: v ** 2 / norm for k, v in count_shops.items()}
    return norm_shops


def shop_count_sim(u_shops, v_shops):
    """
    Return the cosine similarity between 2 normalized dicts
    """
    list1, list2 = sorted(u_shops.items()), sorted(v_shops.items())  # is sorted or not?
    id1 = id2 = dot = 0
    while id1 < len(list1) and id2 < len(list2):
        if list1[id1][0] == list2[id2][0]:
            dot += list1[id1][1] * list2[id2][1]
            id1 += 1
            id2 += 1
        elif list1[id1][0] < list2[id2][0]:
            id1 += 1
        else:
            id2 += 1
    return dot


def recommend(user_id, plot=False, print_time=False):
    try:
        user_id = ObjectId(user_id)
    except:
        pass

    t0 = time()
    # Get necessary info
    u_info = getUser(['preferences', 'location'], _id=user_id)[0]
    users = getUser(['_id']) # all users
    """
    capar el nombre de users a 500:
    """
    if len(users) > 500:
        users = random.sample(users, k=500)

    print(users, type(users))

    all_trans = getTransaction(['shop_id', 'user_id'], user_id=users)
    all_shops = getShop(['location', 'tags'])
    shop_ids = [s["_id"] for s in all_shops]
    u_shops = get_shop_count(user_id, all_trans)

    t1 = time()
    if print_time: print(t1 - t0)
    
    # To new users, recommend shops in its zip code with preferences
    #if len(u_shops) < 2:
    #    return recommend_new_user(user_id)

    # Find similar users and shops where they buy
    sims = []
    for v in users:
        v = v['_id']
        v_shops = get_shop_count(v, all_trans)
        uv_sim = shop_count_sim(u_shops, v_shops)
        sims.append((v, uv_sim))
    sims = sorted(sims, key=lambda x: -x[1])
    sims = sims[0:20]  # Hyperparameter

    shops = {s: 0.1 for s in shop_ids}
    for v, sim in sims:
        v_shops = get_shop_count(v, all_trans)
        for shop, count in v_shops.items():
            score = sim * count
            shops[shop] += score
    
    #return sorted(shops.items(), key=lambda x: -x[1])[:20]


    t2 = time()
    if print_time: print(t2-t1)
    shop_info = [s for s in all_shops if s['_id'] in shops.keys()]
    u_shop_info = [s for s in all_shops if s['_id'] in u_shops.keys()]

    # Ponderate by distance
    """
    shop_ids = [s for s,_ in u_shops.items()]
    u_locs = [s['location'] for s in u_shop_info]
    lats, lons = [lat for lat, _ in u_locs], [lon for _, lon in u_locs]
    u_loc = np.mean(lats), np.mean(lons)
    """
    s_locs = {s['_id']: s['location'] for s in shop_info}
    dists = {s_id: distance(u_info["location"], s_loc).km for s_id, s_loc in s_locs.items()}
    max_dist = max(dists.values())
    dists = {s_id: s_dist / max_dist for s_id, s_dist in dists.items()}
    dist_scores = {s_id: np.pi / 2 - np.arctan(s_dist) for s_id, s_dist in dists.items()}  # hyperparameter
    shops = {sh: sc * dist_scores[sh] for sh, sc in shops.items()}


    # Sum if user interested in shop tags or bought in similar shops
    preferences = {}
    for s in u_shop_info:
        shop_id, tags = s['_id'], s['tags']
        for t in tags:
            if t in preferences:
                preferences[t] += u_shops[shop_id]
    norm = sum(preferences.values())
    preferences = {k: v / norm for k, v in preferences.items()}
    explicit_prefs = u_info['preferences']
    for t in explicit_prefs:
        if t in preferences:
            preferences[t] += 1/len(explicit_prefs)  # hyperparameter
        else:
            preferences[t] = 1/len(explicit_prefs)  # hyperparameter
    for info, (sh, score) in zip(shop_info, shops.items()):
        for tag in info['tags']:
            if tag in preferences:
                shops[sh] *= preferences[tag] # hyperparameter

    t3 = time()
    if print_time: print(t3 - t2)


    shops = sorted(shops.items(), key=lambda x: -x[1])[:30]  # Hyperparameter
    #return shops
    #return shops[:20]
    return random.sample(shops, k=20)

    # Factors: visited or not, air pollution...
