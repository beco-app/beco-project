import argparse
import json
from extraction_routine import sensors_api_query, token

parser = argparse.ArgumentParser()

#-n BOUNDING_BOX_NAME -lat1 LAT1 -lng1 LNG1 -lat2 LAT2 -lng2 LNG2
parser.add_argument("-n", "--bb_name")
parser.add_argument("-lat1", "--lat1", type=float)
parser.add_argument("-lng1", "--lng1", type=float)
parser.add_argument("-lat2", "--lat2", type=float, default=None, required=False)
parser.add_argument("-lng2", "--lng2", type=float, default=None, required=False)

args = parser.parse_args()

extraction = sensors_api_query(token, args.lat1, args.lng1, args.lat2, args.lng2)

if 'status' in extraction and extraction['status'] == 'ok':
    with open('./stations.json', 'r') as json_file:
        stations = json.load(json_file)
        for st in extraction['data']:
            stations[st['uid']] = st['station']
    with open('./stations.json', 'w') as json_file:
        json.dump(stations, json_file, ensure_ascii=False, indent=2)

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
    raise Exception()
