import requests
import json
import pandas as pd
from tqdm import tqdm

token = '5ba0f3024f257b103b04cc3fd569a67994c57e2e'

def sensors_api_query(token, lat1, lng1, lat2, lng2):
    latlng = f'{lat2},{lng2},{lat1},{lng1}'
    link = f'https://api.waqi.info/map/bounds/?token={token}&latlng={latlng}'

    file = requests.get(link)
    return json.loads(file.text) # ara res és un json (diccionari de diccionaris)

def api_response_parsing(response):
    print('prova')
    pass

def update_all_stations():
    with open('./bounding_boxes.json') as json_file:
        bounding_boxes = json.load(json_file)

    for bb in tqdm(bounding_boxes):
        print(sensors_api_query(token, bb['lat1'], bb['lng1'], bb['lat2'], bb['lng2']))
        api_response_parsing(sensors_api_query(token, bb['lat1'], bb['lng1'], bb['lat2'], bb['lng2']))


def main():
    update_all_stations()

if __name__ == '__main__':
    main()
