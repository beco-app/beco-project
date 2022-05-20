from tools import *
from recommender import recommend
from simulate_transactions import computeScores, transaction_gen
from time import time
import numpy as np
from bson.objectid import ObjectId
from populate_users import populate_users
import matplotlib.pyplot as plt
from tqdm import tqdm

def evaluate(verbose=True):
    #print("evaluate")
    t0 = time()
    f = open('./backend/data_base/latent.csv', 'r')
    latent = [r[:-1].split(',') for r in f.readlines()]
    latent = {ObjectId(r[0]): {'freq': float(r[1]), 
                               'fidelity': float(r[2]),
                               'laziness': float(r[3]),
                               'pickiness': float(r[4])} for r in latent}
    
    all_users = getUser() # all users from db with all fields
    all_shops = getShop() # all shops from db with all fields
    all_transactions = getTransaction()
    tables = [all_users, all_shops, all_transactions]
    all_users = {user["_id"]: user for user in all_users} # index users by id
    all_shops = {shop["_id"]: shop for shop in all_shops} # index shops by id


    scores = []
    t1 = time()
    #print(t1 - t0)
    if verbose:
        latent_iter = tqdm(latent.keys())
    else:
        latent_iter = latent.keys()
    for u in latent_iter:
        recom = recommend(u, print_time=False, tables=tables)
        #print('-'*10)
        u_trans = [t['shop_id'] for t in all_transactions if t['user_id'] == u]
        u_scores = computeScores(all_shops, all_users[u], u_trans, latent[u])
        max_score = sum(sorted(u_scores.values())[-20:])
        recom_score = sum([u_scores[s[0]] for s in recom])
        scores.append((recom_score, max_score))
    t2 = time()
    #print(t2 - t1)
    
    avg_recom_score = np.mean([s[0] for s in scores])
    avg_max_score = np.mean([s[1] for s in scores])
    avg_ratio = np.mean([s[0]/s[1] for s in scores])
    if verbose:
        print("Average recommendation score:", avg_recom_score)
        print("Average maximum score:", avg_max_score)
        print("Ratio of averages:", avg_recom_score / avg_max_score)
        print("Average ratio:", avg_ratio)
    return avg_ratio


def evaluate_time(days, start=10, factor=0.1, plot=False):
    """
    Simulate increasing users behavior during some days
    and evaluate the recommender after each one
    Execute in local, and first wipe out users and transactions collections!
    """
    new_users = start
    current_users = 0
    accuracies = []
    n_users = []
    n_trans = []
    for d in tqdm(range(days)):
        t0 = time()
        populate_users(new_users, verbose=False)
        t1 = time()
        #print(t1 - t0)
        transaction_gen(n_days=1, verbose=False)
        t2 = time()
        #print(t2 - t1)
        current_users += new_users
        accuracies.append(evaluate(verbose=False))
        n_users.append(current_users)
        n_trans.append(len(getTransaction()))
        new_users = int(current_users * factor)
        t3 = time()
        #print(t3 - t2)

    plt.plot(n_users, accuracies)
    plt.title("Accuracy vs number of users")
    plt.show()
    plt.plot(n_trans, accuracies)
    plt.title("Accuracy vs number of transactions")
    plt.show()

    return n_users, n_trans, accuracies


if __name__ == '__main__':
    evaluate_time(30)
