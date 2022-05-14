from tools import *
from recommender import recommend
from simulate_transactions import computeScores, transaction_gen
from time import time
import numpy as np
from tqdm import tqdm
from bson.objectid import ObjectId
from populate_users import populate_users
import matplotlib.pyplot as plt
from tqdm import tqdm

def evaluate(verbose=True):
    f = open('./backend/data_base/latent.csv', 'r')
    latent = [r[:-1].split(',') for r in f.readlines()]
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
    for u in tqdm(latent.keys()):
        recom = recommend(u)
        u_trans = [t['shop_id'] for t in all_transactions if t['user_id'] == u]
        u_scores = computeScores(all_shops, all_users[u], u_trans, latent[u])
        max_score = sum(sorted(u_scores.values())[-10:])
        recom_score = sum([u_scores[s[0]] for s in recom])
        scores.append((recom_score, max_score))
    
    avg_recom_score = np.mean([s[0] for s in scores])
    avg_max_score = np.mean([s[1] for s in scores])
    avg_ratio = np.mean([s[0]/s[1] for s in scores])
    if verbose:
        print("Average recommendation score:", avg_recom_score)
        print("Average maximum score:", avg_max_score)
        print("Ratio of averages:", avg_recom_score / avg_max_score)
        print("Average ratio:", avg_ratio)
    return avg_ratio


def evaluate_time(days, start=10, factor=0.1):
    """
    Simulate increasing users behavior during some days
    and evaluate the recommender after each one
    Execute in local, and first wipe out users and transactions collections!
    """
    new_users = start
    accuracies = []
    n_users = []
    n_trans = []
    for d in tqdm(range(days)):
        populate_users(new_users)
        transaction_gen(n_days=1)
        current_users = len(getUser())
        accuracies.append(evaluate())
        n_users.append(current_users)
        n_trans.append(len(getTransaction))
        new_users = int(current_users * factor)
    
    plt.plot(n_users, accuracies)
    plt.show()
    plt.plot(n_trans, accuracies)
    plt.show()


if __name__ == '__main__':
    evaluate_time(50)
