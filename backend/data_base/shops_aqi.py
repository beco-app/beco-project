# -*- stores_aqi.py -*-

"""
The aim of this python script is to asign the air quality index
to a given store.
"""

import numpy as np
import json
import time

__author__ = '[Gerard Calvo, Pau Matas]'
__maintainer__ = 'Gerard Calvo'
__email__ = 'gerardcalvo26@gmail.com'
__status__ = 'Dev'

available_stations = set()

def get_shop_aqi(store_id):
    calling_time = time.time()

    with open('./stores.json', 'r') as json_file:
        stores_json = json.load(json_file)
    nearest_stations = stores_json[store_id]["nearest_stations"]

    with open('./stations.json', 'r') as json_file:
        stations_json = json.load(json_file)

    station_aqis_dist_time = []
    total_dist = 0
    sum_elapsed_time = 0
    for station_id, distance in nearest_stations.items():
        if station_id in available_stations: #wtf es available_stations
            station_aqi = stations_json[station_id]["aqi"]
            station_time = stations_json[station_id]["time"] #cal transformar a timestamp
            elapsed_time = calling_time - station_time
            station_aqis_dist_time.append(station_aqi, distance, elapsed_time)
            sum_elapsed_time += elapsed_time
            total_dist += distance
        else:
            print(f'Warning: Station {station_id} has no available AQI measure')
    store_aqi = np.sum(
            [aqi*(1-distance/total_dist)*(1-elapsed_time/sum_elapsed_time) 
            for aqi, distance, elapsed_time in station_aqis_dist_time]
        )/(len(station_aqis_dist_time)-1)
    return store_aqi
