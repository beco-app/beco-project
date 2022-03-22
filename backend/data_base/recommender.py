import sys
sys.path.append("./backend/data_base")
from tools import *
from collections import Counter
from geopy.distance import distance
import numpy as np
from bson.objectid import ObjectId

def get_shop_count(uid):
    """
    Return all shops where uid has buyed and how many times (normalized)
    Return in a dict {shop_id: normalized_times}
    """
    all_trans = getTransaction(['shop_id'], user_id=uid)
    all_shops = [t['shop_id'] for t in all_trans]
    count_shops = Counter(all_shops)
    norm = sum([v**2 for v in count_shops.values()])
    norm_shops = {k: v**2/norm for k, v in count_shops.items()}
    return norm_shops


def shop_count_sim(u_shops, v_shops):
    """
    Return the cosine similarity between 2 normalized dicts
    """
    list1, list2 = sorted(u_shops.items()), sorted(v_shops.items()) # is sorted or not?
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
    #print(dot, end='')
    return dot


def recommend(user_id):

    # Find most similar users
    u_shops = get_shop_count(user_id)
    users = getUser(['_id'])
    sims = []
    for v in users:
        v = v['_id']
        v_shops = get_shop_count(v)
        uv_sim = shop_count_sim(u_shops, v_shops)
        sims.append((v, uv_sim))
    sims = sorted(sims, key=lambda x: -x[1])
    sims = sims[0:20]  #Hyperparameter

    # Find most similar shops
    shops = {}
    for v, sim in sims:
        v_shops = get_shop_count(v)
        for shop, count in v_shops.items():
            score = sim * count
            if shop in shops.keys():
                shops[shop] += score
            else:
                shops[shop] = score
    

    # Compute approx ubication of user and ponderate by distance

    def eval_loc(loc_str):
        lat = float(eval(loc_str)[0].replace(',', '.'))
        lon = float(eval(loc_str)[1].replace(',', '.'))
        return lat, lon
    
    u_locs = [eval_loc(getShop([], _id=s)[0]['location']) for s, _ in u_shops.items()]
    lats, lons = [lat for lat, _ in u_locs], [lon for _, lon in u_locs]
    loc = np.mean(lats), np.mean(lons)
    s_locs = [eval_loc(getShop([], _id=s)[0]['location']) for s in shops.keys()]
    dists = [distance(loc, s_loc).km for s_loc in s_locs]
    dists = np.array(dists) / max(dists)
    dist_scores = [np.pi / 2 - np.arctan(d) for d in dists]  # hyperparameter
    shops = {sh: sc*dist_scores[i] for i, (sh, sc) in enumerate(shops.items())}

    # Sum if user and shop are vegan

    if getUser([], _id=user_id)[0]['diet'] == 'Vegan':  # Add more types?
        for sh, _ in shops.items():
            if getShop([], _id=sh)[0]['type'] == 'vegan food':
                shops[sh] *= 1.2  # Hyperparameter

    
    return sorted(shops.items(), key=lambda x: -x[1])

    # Factors: visited or not, air pollution...
