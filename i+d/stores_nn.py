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

    dist, idx = stations_tree.query_radius(
        [(store['lat'] * pi/180, store['lon'] * pi/180) for store in stores],
        r=2000.0
    )
    # dist, idx = stations_tree.query(
    #     [(store['lat'] * pi/180, store['lon'] * pi/180) for store in stores],
    #     k=3
    # )
    dist *= earth_radius

    print(dist)
    print(idx)

    near_stations = {
        store['id']: [
            (list(stations.keys())[station_idx], np.round(d,2))
            for station_idx, d in zip(idx[i], dist[i])
        ]
        for i, store in enumerate(stores)
    }
    print(near_stations)

foo()
