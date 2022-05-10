from tools import *
from recommender import recommend
from simulate_transactions import computeScores
from time import time
import numpy as np
from bson.objectid import ObjectId

def evaluate():
    f = open('./backend/data_base/latent.csv', 'r')
    latent = [r[:-1].split(',') for r in f.readlines()]
    print(latent)
    latent = {ObjectId(r[0]): {'freq': float(r[1]), 
                               'fidelity': float(r[2]),
                               'laziness': float(r[3]),
                               'pickiness': float(r[4])} for r in latent}
    all_users = getUser() # all users from db with all fields
    all_users = {user["_id"]: user for user in all_users} # index users by id
    all_shops = getShop() # all shops from db with all fields
    all_shops = {shop["_id"]: shop for shop in all_shops} # index shops by id
    all_transactions = getTransaction()

    scores = []
    for u in latent.keys():
        recom = recommend(u)
        u_trans = [t['shop_id'] for t in all_transactions if t['user_id'] == u]
        u_scores = computeScores(all_shops, all_users[u], u_trans, latent[u])
        max_score = sum(sorted(u_scores.values())[-10:])
        recom_score = sum([u_scores[s[0]] for s in recom])
        scores.append((recom_score, max_score))
    
    avg_recom_score = np.mean([s[0] for s in scores])
    avg_max_score = np.mean([s[1] for s in scores])
    ratio = np.mean([s[0] / s[1] for s in scores])
    return ratio
