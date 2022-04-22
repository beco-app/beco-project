import numpy as np
import pandas as pd
import csv
from geopy.geocoders import Nominatim
from tqdm import tqdm
geolocator = Nominatim(user_agent="geoapiExercises")

bcnsost = pd.read_csv("./bcnsostenible.csv", sep='\t')

# Attribute processing
bcnsost.drop(['Icona ' + str(i) for i in range(2, 33)], inplace = True, axis=1)
bcnsost.drop(['Xarxa social ' + str(i) for i in range(1, 5)], inplace = True, axis=1)
bcnsost["location"] = list(zip(list(bcnsost["Latitud"]), list(bcnsost["Longitud"])))
bcnsost.drop(['Codi', 'URL', 'E-mail', 'Itineraris', 'Telèfon', 'Icona 1 (Principal)', 'Latitud', 'Longitud'], inplace = True, axis=1)
bcnsost = bcnsost.rename(columns={
    'Nom': 'shopname', 'Telèfon': 'shop phone', 'Descripció': 'description', 'Web': 'web', 'Adreça': 'address', 
    'Districte': 'district', 'Barri': 'neighbourhood'})

# Filter shops
bcnsost = bcnsost.loc[['comerç verd' in str(tags) for tags in list(bcnsost['Etiquetes'])]]
bcnsost.drop('Etiquetes', inplace=True, axis=1)

# Add attributes and generate random
from random import choices, sample
types = ['restaurant', 'bar', 'supermarket', 'alimentation', 'beverages', 'bakery',
         'fruits & vegetables', 'pharmacy', 'cosmetics', 'herbalist', 'non-alimentation', 'others']
types_sample = choices(types, k=len(bcnsost))
bcnsost['type'] = types_sample
tags = ['restaurant', 'bar', 'supermarket', 'bakery', 'vegan food', 'vegetarian food',
         'beverages', 'alimentation', 'local products', 'green space', 'plastic free',
         'zero waste', 'herbalist', 'second hand', 'in bulk', 'cosmetics', 'pharmacy',
         'fruits & vegetables', 'recycled material', 'others']
tags_sample = [sample(tags, k=3) for i in range(len(bcnsost))]
bcnsost['tags'] = tags_sample
bcnsost['timetable'] = [None]*len(bcnsost)
bcnsost['photo'] = [None]*len(bcnsost)
bcnsost['product_list'] = [None]*len(bcnsost)
bcnsost['phone'] = [None]*len(bcnsost)

# Get zip codes
bcnsost = bcnsost[bcnsost['address'].notna()]
full_address = zip(bcnsost['address'], bcnsost['district'], bcnsost['neighbourhood'])
full_address = [', '.join(add) for add in full_address]
full_address = [geolocator.geocode(add) for add in tqdm(full_address)]
bcnsost = bcnsost[[add is not None for add in full_address]]
full_address = [add for add in full_address if add is not None]
zip_codes = [add[0].split(', ')[-2] for add in full_address]
bcnsost['zip_code'] = zip_codes
colnames = bcnsost.columns.tolist()
colnames = colnames[:7] + [colnames[-1]] + colnames[7:-1]
bcnsost = bcnsost[colnames]

bcnsost.to_csv('shops.csv')