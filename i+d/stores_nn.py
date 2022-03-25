# -*- stores_nn.py -*-

"""
The aim of this python script is to asign the k-nearest neighbour air quality
sensors stations to a store.
"""

# Libs
from sklearn.neighbors import BallTree
import numpy as np
from numpy import pi
import pandas as pd
import hashlib
import requests
import json

__author__ = '[Gerard Calvo, Pau Matas]'
__maintainer__ = 'Pau Matas'
__email__ = 'pmatasalbiol@gmail.com'
__status__ = 'Dev'

# Global vars
FILES_PATH = "/Users/pau_matas/Desktop/GCED/Q6/PE/beco-project/i+d/"
earth_radius = 6371008

def foo():
    with open(f"{FILES_PATH}stations.json") as json_file:
        stations = json.load(json_file)
    with open(f"{FILES_PATH}stores.json") as json_file:
        stores = json.load(json_file)

    stations_tree = BallTree(
        np.deg2rad([(st['lat'], st['lon']) for st in stations.values()]),
        metric = 'haversine'
    )

    idxs = list()
    dists = list()
    for store in stores:
        idx, dist = idx_dist(stations_tree, store)
        idxs += [idx]
        dists += [dist]

    near_stations = {
        store['id']: [
            (list(stations.keys())[station_idx], np.round(d,2))
            for station_idx, d in zip(idxs[i], dists[i])
        ]
        for i, store in enumerate(stores)
    }
    print(near_stations)

def idx_dist(stations_tree, store):
    idx, dist = stations_tree.query_radius(
        [(store['lat'] * pi/180, store['lon'] * pi/180)],
        r=4000/earth_radius,
        return_distance = True
    )
    idx = [l.tolist() for l in idx.tolist()]
    dist = [l.tolist() for l in dist.tolist()]
    if idx[0]:
        return idx[0], [d * earth_radius for d in dist[0]]

    dist, idx = stations_tree.query(
        [(store['lat'] * pi/180, store['lon'] * pi/180)],
        k=1
    )
    idx = idx.tolist()
    dist = dist.tolist()
    return idx[0], [d * earth_radius for d in dist[0]]


foo()
