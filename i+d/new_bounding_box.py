# -*- new_bounding_box.py -*-

"""
Python script designed to add bounding boxes to 'bounding_boxes.json'.

A bounding box is a geographic obejct which given two opposite corners draws a
square over the map. Every bounding box has also a name. These objects are
thougth to be used in 'https://api.waqi.info/' and recieve the data of air
quality indexes from the sensors located inside the box. This api has antoher
function for individual geographic point returning the nearest station and its
data for the point. So a bounding box with only a one corner will be one of
those points.

Every corner is composed of a latitude and a longitude, so in order to add one
object to the JSON file you must follow one of the following command skeletons:
* New bounding box:
    $ python3 new_bounding_box.py -n BOUNDING_BOX_NAME -lat1 LAT1 -lng1 LNG1 -lat2 LAT2 -lng2 LNG2
* New point:
    $ python3 new_bounding_box.py -n POINT_NAME -lat1 LAT1 -lng1 LNG1
"""

# Libs
import argparse
import json

# Own modules
from extraction_routine import sensors_api_query, token

__author__ = 'Pau Matas'
__maintainer__ = 'Pau Matas'
__email__ = 'pmatasalbiol@gmail.com'
__status__ = 'Dev'

# Arguments reading
parser = argparse.ArgumentParser()

#-n BOUNDING_BOX_NAME -lat1 LAT1 -lng1 LNG1 -lat2 LAT2 -lng2 LNG2
parser.add_argument("-n", "--bb_name")
parser.add_argument("-lat1", "--lat1", type=float)
parser.add_argument("-lng1", "--lng1", type=float)
parser.add_argument("-lat2", "--lat2", type=float, default=None, required=False)
parser.add_argument("-lng2", "--lng2", type=float, default=None, required=False)

args = parser.parse_args()

# API data extraction
extraction = sensors_api_query(
    token, args.lat1, args.lng1, args.lat2, args.lng2
)

if 'status' in extraction and extraction['status'] == 'ok': # Extr. succesful
    # Update stations information adding the new stations detected by the new
    # bounding box.
    with open('./stations.json', 'r') as json_file:
        stations = json.load(json_file)
        for st in extraction['data']:
            if not st['uid'] in stations:
                stations[st['uid']] = st['station']
                stations[st['uid']]['lat'] = st['lat']
                stations[st['uid']]['lng'] = st['lon']
                stations[st['uid']]['aqi'] = None
    with open('./stations.json', 'w') as json_file:
        json.dump(stations, json_file, ensure_ascii=False, indent=2)

    # Update 'bounding_boxes.json' file
    with open('./bounding_boxes.json', 'r') as json_file:
        bounding_boxes = json.load(json_file)
        bb_names_set = {bb['name'] for bb in bounding_boxes}
        if not args.bb_name in bb_names_set:
            bounding_boxes.append({
                'name': args.bb_name,
                'lat1': args.lat1,
                'lng1': args.lng1,
                'lat2': args.lat2,
                'lng2': args.lng2
            })
    with open('./bounding_boxes.json', 'w') as json_file:
        json.dump(bounding_boxes, json_file, ensure_ascii=False, indent=2)

else:
    raise Exception((
        f'Extraction failed for bounding box {args.bb_name}:\n'
        f'latitude1: {args.lat1}, longitude1: {args.lng1}\n'
        f'latitude2: {args.lat2}, longitude2: {args.lng2}\n'
        ))
