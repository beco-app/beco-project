import requests
import json
import pandas as pd
from tqdm import tqdm

token = '5ba0f3024f257b103b04cc3fd569a67994c57e2e'

def sensors_api_query(token, lat1, lng1, lat2, lng2):
    latlng = f'{lat2},{lng2},{lat1},{lng1}'
    link = f'https://api.waqi.info/map/bounds/?token={token}&latlng={latlng}'

    file = requests.get(link)
    return json.loads(file.text)

def api_response_parsing(response):
    extraction_json = [
        {
            'uid':station['uid'],
            'aqi':float(station['aqi']),
            'time':station['station']['time']
        }
        for station in response['data']
        if station['aqi'] != '-'
    ]
    if not extraction_json:
        print('Nothing to extract...')

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
        api_response_parsing(sensors_api_query(
            token, bb['lat1'], bb['lng1'], bb['lat2'], bb['lng2']
            ))

def main():
    update_all_stations()

if __name__ == '__main__':
    main()
