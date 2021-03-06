# -*- shops_nn.py -*-

"""
The aim of this python script is to asign the k-nearest neighbour air quality
sensors stations to a shop.
"""

# Libs
from sklearn.neighbors import BallTree
import numpy as np
from numpy import pi
import json

# Own modules
from tools import getShop
from extraction_routine import FILES_PATH

__author__ = '[Gerard Calvo, Yikai Qiu, Pau Matas]'
__maintainer__ = 'Pau Matas'
__email__ = 'pmatasalbiol@gmail.com'
__status__ = 'Dev'

# Global vars
earth_radius = 6371008

def get_shops_nearest_stations():
    with open(f"{FILES_PATH}stations.json") as json_file:
        stations = json.load(json_file)
    
    shops = getShop('location')

    stations_tree = BallTree(
        np.deg2rad([(st['lat'], st['lon']) for st in stations.values()]),
        metric = 'haversine'
    )

    idxs, dists = shops_nearest_stations_list(stations_tree, shops)

    near_stations = {
        shop['_id']: {
            list(stations.keys())[station_idx]: np.round(d,2)
            for station_idx, d in zip(idxs[i], dists[i])
        }
        for i, shop in enumerate(shops)
    }

    return near_stations

def shops_nearest_stations_list(stations_tree, shops, radius=4000):
    """
    Returns two lists defining the nearest stations for every shop in `shops`.
    The first one elements are the `stations.values()` list indexes of the
    shop's nearest stations, and the second list returned has the distances
    between the shop and the nearest stations as elements.
    The order in the lists corresponds to the order of the shops in the list
    `shops`. The order of the elements of those lists are determined by the
    increasing distances between the stations and the shops.
    So, `dists[i][j]` will be the distance between the `shops`' i-th shop and
    the j-th nearest station; in addition, this station will be the
    idxs[i][j]-th station in the list `stations`.

    It will also return the nearest stations within a radius of `radius` meters
    from the shop. If there isn't any station in that radius will simply return
    the nearest one.
    """
    idxs = []
    dists = []
    for shop in shops:
        idx, dist = nearest_station_idx_and_dist(stations_tree, shop, radius)
        idxs += [idx]
        dists += [dist]
    return idxs, dists

def nearest_station_idx_and_dist(stations_tree, shop, radius):
    """ Given a shop and a stations_tree BallTree returns the idx and dist of
        their nearest stations in a radius `radius` or from the nearest one if
        there isn't no station within this radius.
    """
    idx, dist = stations_tree.query_radius(
        [(shop['location'][0] * pi/180, shop['location'][1] * pi/180)],
        r=radius/earth_radius,
        return_distance = True
    )
    idx = [l.tolist() for l in idx.tolist()]
    dist = [l.tolist() for l in dist.tolist()]
    if idx[0]:
        return idx[0], [d * earth_radius for d in dist[0]]

    dist, idx = stations_tree.query(
        [(shop['location'][0] * pi/180, shop['location'][1] * pi/180)],
        k=1
    )
    idx = idx.tolist()
    dist = dist.tolist()
    return idx[0], [d * earth_radius for d in dist[0]]
