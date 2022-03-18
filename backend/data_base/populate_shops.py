import tools as tools
import random
import hashlib
from tools import setShop
import csv
import pymongo

def populate_shops(src):
    with open(src) as f:
        shops = [{k: v for k, v in list(row.items())[1:]}
            for row in csv.DictReader(f, skipinitialspace=True)]

    for s in shops:
        print(setShop(s))

if __name__ == '__main__':
    populate_shops('shops.csv')

    
