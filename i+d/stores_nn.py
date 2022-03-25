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

    idxs, dists = stores_nearest_stations_list()

    near_stations = {
        store['id']: [
            (list(stations.keys())[station_idx], np.round(d,2))
            for station_idx, d in zip(idxs[i], dists[i])
        ]
        for i, store in enumerate(stores)
    }
    print(near_stations)

def stores_nearest_stations_list(stations_tree, stores, radius=4000):
    """
    Returns two lists defining the nearest stations for every store in `stores`.
    The first one elements are the `stations.values()` list indexes of the
    store's nearest stations, and the second list returned has the distances
    between the store and the nearest stations as elements.
    The order in the lists corresponds to the order of the stores in the list
    `stores`. The order of the elements of those lists are determined by the
    increasing distances between the stations and the stores.
    So, `dists[i][j]` will be the distance between the `stores`' i-th store and
    the j-th nearest station; in addition, this station will be the
    idxs[i][j]-th station in the list `stations`.

    It will also return the nearest stations within a radius of `radius` meters
    from the store. If there isn't any station in that radius will simply return
    the nearest one.
    """
    idxs = []
    dists = []
    for store in stores:
        idx, dist = idx_dist(stations_tree, store, radius)
        idxs += [idx]
        dists += [dist]
    return idxs, dists

def idx_dist(stations_tree, store, radius):
    idx, dist = stations_tree.query_radius(
        [(store['lat'] * pi/180, store['lon'] * pi/180)],
        r=radius/earth_radius,
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
