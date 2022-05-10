# -*- stores_aqi.py -*-

"""
The aim of this python script is to asign the air quality index
to a given store.
"""

import os
import numpy as np
import json
import time
from datetime import datetime as dt

import tools

__author__ = '[Gerard Calvo, Pau Matas]'
__maintainer__ = 'Gerard Calvo'
__email__ = 'gerardcalvo26@gmail.com'
__status__ = 'Dev'

available_stations = set()

def get_shop_aqi(shop_id):
    calling_time = time.time()

    nearest_stations = tools.getShop(_id=shop_id)[0]["nearest_stations"]

    with open(os.path.dirname(os.path.abspath(__file__))+'/stations.json', 'r', encoding='utf-8') as json_file:
        stations_json = json.load(json_file)

    station_aqis_dist_time = []
    total_dist = 0
    sum_elapsed_time = 0
    for station_id, distance in nearest_stations.items():
        if stations_json[station_id]["aqi"] is not None: #wtf es available_stations
            station_aqi = stations_json[station_id]["aqi"]

            station_time = stations_json[station_id]["time"] #cal transformar a timestamp
            station_time = time.mktime(dt.fromisoformat(station_time).timetuple())
            elapsed_time = calling_time - station_time

            station_aqis_dist_time.append((station_aqi, distance, elapsed_time))
            sum_elapsed_time += elapsed_time
            total_dist += distance
        else:
            print(f'Warning: Station {station_id} has no available AQI measure')
    store_aqi = np.sum(
            [aqi*(1-distance/total_dist)*(1-elapsed_time/sum_elapsed_time) 
            for aqi, distance, elapsed_time in station_aqis_dist_time]
        )/(len(station_aqis_dist_time)-1)
    return store_aqi
