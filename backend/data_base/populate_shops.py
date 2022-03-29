
from numpy import product
import tools as tools
import random
import hashlib
from tools import setShop
import csv
import pymongo
import random

def populate_shops(src):
    """
    Function that populates the the shop database.
    The input is the source file path
    """
    random.seed(123456789)
    with open(src) as f:
        for row in csv.DictReader(f, skipinitialspace=True):

            items = [ v for k,v in list(row.items())[1:]]

            shopname, description, web, address, district, neighbourhood, location, _type, timetable, photo, product_list, phone = items
            lat, lon = eval(location)
            location = (float(lat.replace(',', '.')), float(lon.replace(',', '.')))
            #phone = '2' + str(random.randrange(0,99_999_999)).zfill(8)

            shop = {
                'shopname':shopname, 'description': description, 'web':web, 'timetable': timetable, 
                'photo':photo, 'location': location, 'address':address, 'district':district,
                'neighbourhood': neighbourhood, 'type': _type, 'product_list': product_list, 'phone': phone
            }
            print(setShop(shop))
            #print(shop)

if __name__ == '__main__':
    populate_shops('./backend/data_base/shops.csv')