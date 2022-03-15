import tools as tools
import random
import hashlib
from tools import setShop



import csv
import pymongo
client = pymongo.MongoClient()
db = client.beco_db
collection = db.shops

with open('shops.csv') as f:
    shops = [{k: v for k, v in list(row.items())[1:]}
        for row in csv.DictReader(f, skipinitialspace=True)]

for s in shops:
    setShop(s)
