import sys
sys.path.append("./backend/data_base")

from numpy import product
# import tools as tools
import random
import hashlib
from tools import setShop, updateShop, getShop
import csv
import pymongo
import json
import random
from shops_nearest_stations import get_shops_nearest_stations
import json

def populate_shops(src):
    """
    Function that populates the the shop database.
    The input is the source file path
    """
    photo_links = json.load(open("./backend/data_base/photos.json"))['photos']
    random.seed(123456789)

    with open(src) as f:
        for row in csv.DictReader(f, skipinitialspace=True):

            items = [ v for k,v in list(row.items())[1:]]

            shopname, description, web, address, district, neighbourhood, location, zip_code, _type, tags, timetable, photo, product_list, phone = items
            idx = random.randint(0, len(photo_links)-1) # random [0,15]
            #photo = "https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png"
            photo = photo_links[idx]
            tags = eval(tags)
            lat, lon = eval(location)
            location = (float(lat.replace(',', '.')), float(lon.replace(',', '.')))
            #phone = '2' + str(random.randrange(0,99_999_999)).zfill(8)

            shop = {
                'shopname':shopname, 'description': description, 'web':web, 'timetable': timetable, 'photo':photo,
                'location': location, 'address':address, 'district':district, 'zip_code':zip_code,
                'neighbourhood': neighbourhood, 'type': _type, 'tags': tags, 'product_list': product_list, 'phone': phone,
                'nearest_stations': None
            }

            print(setShop(shop))
            #print(shop)
    print("Building the set of nearest stations for each shop...")
    stations = get_shops_nearest_stations() # {ObjectId(...):{'station_id':distance, 'station_id':distance, ...}, ...}
    for shop in getShop('_id'):
        shop_id = shop['_id']
        print(f'Setting nearest shops for {shop_id}... ', end='')
        print(updateShop(shop_id, nearest_stations=stations[shop_id]))

if __name__ == '__main__':
    populate_shops('./backend/data_base/shops_upper.csv')
