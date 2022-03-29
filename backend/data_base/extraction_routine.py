# -*- extraction_routine.py -*-

"""
Python script designed to update the stations file with data extracted form the
air quality index api ('https://api.waqi.info/').
It is thought to be executed daily with an external programming tool. In our
case we use 'crontab' with a command '0 */8 * * *'.

It has also isolated functions able to query the api without updating the
stations file so it can be used as a module.
"""

# Libs
import requests
import json
import pandas as pd
from tqdm import tqdm
import datetime

__author__ = 'Pau Matas'
__maintainer__ = 'Pau Matas'
__email__ = 'pmatasalbiol@gmail.com'
__status__ = 'Dev'

# Global variables
token = '5ba0f3024f257b103b04cc3fd569a67994c57e2e'
FILES_PATH = "~/beco-project/backend/data_base/"
# FILES_PATH = "./backend/data_base/"

def sensors_api_query(token, lat1, lng1, lat2=None, lng2=None):
    """ Given a token and one bounding box or point parameters returns the
        response for its query to the api.
    """

    return (
        geo_query_to_latlng_style(sensors_api_geo_query(token, lat1, lng1))
        if lat2 is None and lng2 is None
        else sensors_api_latlng_query(token, lat1, lng1, lat2, lng2)
    )

def sensors_api_latlng_query(token, lat1, lng1, lat2, lng2):
    """ Given a token and one bounding box parameters returns the response for
        its latlng query to the api.
    """
    latlng = f'{lat1},{lng1},{lat2},{lng2}'
    link = f'https://api.waqi.info/map/bounds/?token={token}&latlng={latlng}'

    file = requests.get(link)
    return json.loads(file.text)

def sensors_api_geo_query(token, lat, lng):
    """ Given a token and one geographic point parameters returns the response
        for its geo query to the api.
    """
    link = f'https://api.waqi.info/feed/geo:{lat};{lng}/?token={token}'

    file = requests.get(link)
    return json.loads(file.text)

def geo_query_to_latlng_style(response):
    """ Given geo query response returns it with the latlng query response
        dictionary structure.
    """

    response['data']['station'] = {
        'time': response['data']['time']['iso'],
        'name': response['data']['city']['name'],
    }
    response['data']['lat'], response['data']['lon'] = response['data']['city']['geo']
    response['data']['uid'] = response['data']['idx']
    response['data'] = [response['data']]

    return response

def api_response_parsing(response):
    """ Given a latlng query response updates 'stations.json' file with the air
        quality index data extracted.
    """
    # Select stations with new data
    extraction_json = [
        {
            'uid':str(station['uid']),
            'aqi':float(station['aqi']),
            'time':station['station']['time']
        }
        for station in response['data']
        if station['aqi'] != '-'
    ]
    if not extraction_json:
        print('Nothing to extract...')
        return

    with open(f"{FILES_PATH}stations.json") as json_file:
        stations = json.load(json_file)

    stations = update_aqi(extraction_json, stations)

    with open(f"{FILES_PATH}stations.json", 'w') as json_file:
        json.dump(stations, json_file, ensure_ascii=False, indent=2)

def update_aqi(extraction_json, stations):
    """ Given a extraction and the current stations information, updates and
        returns the stations dictionary.
    """
    for e in extraction_json:
        if e['uid'] in stations:
            stations[e['uid']]['aqi'] = e['aqi']
            stations[e['uid']]['time'] = e['time']
        else:
            print((
                f"Station with uid {e['uid']} does not exist in stations.json "
                f"and is detected as the nearest or inside for a point or a "
                f"bounding box, respectively."))

    return stations

def update_all_stations():
    """ For every bounding box geographic object queries the api and updates
        the stations data file with the data extracted.
    """
    with open(f"{FILES_PATH}bounding_boxes.json") as json_file:
        bounding_boxes = json.load(json_file)

    for bb in tqdm(bounding_boxes):
        print(f"--> {bb['name']}")
        if not 'lat2' in bb:
            bb['lat2'] = None
        if not 'lng2' in bb:
            bb['lng2'] = None

        api_response_parsing(sensors_api_query(
            token, bb['lat1'], bb['lng1'], bb['lat2'], bb['lng2']
            ))

def main():
    print(f"\tExecution at {datetime.datetime.now()}:")
    update_all_stations()
    print('\n\n')

if __name__ == '__main__':
    main()
