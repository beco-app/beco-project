import requests
import json
import pandas as pd
from tqdm import tqdm

token = '5ba0f3024f257b103b04cc3fd569a67994c57e2e'

def sensors_api_geo_query(token, lat, lng):
    link = f'https://api.waqi.info/feed/geo:{lat};{lng}/?token={token}'

    file = requests.get(link)
    return json.loads(file.text)

def sensors_api_latlng_query(token, lat1, lng1, lat2, lng2):
    latlng = f'{lat1},{lng1},{lat2},{lng2}'
    link = f'https://api.waqi.info/map/bounds/?token={token}&latlng={latlng}'

    file = requests.get(link)
    return json.loads(file.text)

def geo_query_to_latlng_style(response):

    response['data']['station'] = {
        'time': response['data']['time']['iso'],
        'name': response['data']['city']['name']
    }
    response['data']['uid'] = response['data']['idx']
    response['data'] = [response['data']]

    return response

def sensors_api_query(token, lat1, lng1, lat2=None, lng2=None):

    return (
        geo_query_to_latlng_style(sensors_api_geo_query(token, lat1, lng1))
        if lat2 is None and lng2 is None
        else sensors_api_latlng_query(token, lat1, lng1, lat2, lng2)
    )

def api_response_parsing(response):
    extraction_json = [
        {
            'uid':str(station['uid']),
            'aqi':float(station['aqi']),
            'time':station['station']['time']
        }
        for station in response['data']
        if station['aqi'] != '-'
    ]
    # if not extraction_json:
    #     print('Nothing to extract...')

    with open('./stations.json') as json_file:
        stations = json.load(json_file)

    stations = update_aqi(extraction_json, stations)

    with open('./stations.json', 'w') as json_file:
        json.dump(stations, json_file, ensure_ascii=False, indent=2)

def update_aqi(extraction_json, stations):
    for e in extraction_json:
        stations[e['uid']]['aqi'] = e['aqi']
        stations[e['uid']]['time'] = e['time']

    return stations

def update_all_stations():
    with open('./bounding_boxes.json') as json_file:
        bounding_boxes = json.load(json_file)

    for bb in tqdm(bounding_boxes):
        if not 'lat2' in bb:
            bb['lat2'] = None
        if not 'lng2' in bb:
            bb['lng2'] = None

        api_response_parsing(sensors_api_query(
            token, bb['lat1'], bb['lng1'], bb['lat2'], bb['lng2']
            ))

def main():
    update_all_stations()

if __name__ == '__main__':
    main()
