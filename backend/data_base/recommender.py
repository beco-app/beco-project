from tools import *
from collections import Counter

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


def sim(u_shops, v_shops):
    """
    Return the cosine similarity between 2 normalized dicts
    """
    list1, list2 = u_shops.items(), v_shops.items() # is sorted or not?
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


def recommend(user_id):
    u_shops = get_shop_count(user_id)
    sims = {}
    for v in users:
        v_shops = get_shop_count(v)
        uv_sim = sim(u_shops, v_shops)
        sims[v] = uv_sim
    # Find most sim users
    # Find shops
    # Factors: distance, visited or not, shop type, user diet, air pollution...
