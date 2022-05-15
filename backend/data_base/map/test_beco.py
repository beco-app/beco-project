import folium
import folium.plugins
import numpy as np
import pandas as pd
from tqdm import tqdm, trange
from selenium import webdriver
import time
from bson.objectid import ObjectId
import os
import sys
sys.path.append(os.getcwd())
from backend.data_base.tools import *
from backend.data_base.recommender import recommend


def show_shops_map(shops, day=0):
    def draw_shop(shop, color, fill_opacity=0.6, radius=2, txt=''):
        lat, lon = shop["location"]
        return folium.CircleMarker(
            location=[lat, lon], 
            popup = f'name:{shop["shopname"]}\n'+txt, 
            radius = max(0.01, radius), 
            color = color, 
            fill_opacity = fill_opacity,
            weight = 1, # gruix perimetre
            fill = True,
            fill_color = color
        )

    mymap = folium.Map(location=(41.401361, 2.174317), zoom_start=13, tiles="cartodbpositron", control_scale=True)

    all_shops_group = folium.FeatureGroup('Shops', overlay=True) # Pots fer capes per filtrar a posteriori
    for _id, shop in shops.items():
        draw_shop(
            shop,
            color = 'green' if shop["n_recom"] > 0 else 'red',
            fill_opacity = 0.1 if shop["n_recom"] > 0 else 0.3,
            radius=5, #(shop["n_recom"]**0.5716)*1.2, #formula per matenir proporcions visuals humanes
            txt=f'Transctions:{np.round(shop["n_recom"]**0.5716*1.2, 2)}',
        ).add_to(all_shops_group)

    all_shops_group.add_to(mymap)
    folium.LayerControl(collapsed=False).add_to(mymap)
    mymap.keep_in_front(all_shops_group)
    mymap.add_child(folium.plugins.Fullscreen())

    title_html = '''
             <h3 align="center" style="font-size:16px"><b>day: {}</b></h3>
             '''.format(day)
    mymap.get_root().html.add_child(folium.Element(title_html))
    return mymap

def preprocessDF(path):
    shops = pd.read_csv(path, index_col=0)
    shops["n_recom"] = 0
    #shops.n_recom = shops.n_recom.map(lambda x: random.randint(0,30))
    shops = shops.set_index(shops._id)
    shops.location = shops.location.map(lambda x: [y.strip("[ '']") for y in x.split(",")])
    shops.tags = shops.tags.map(lambda x: [y.strip("[ '']") for y in x.split(",")])
    shops_dict = shops.to_dict(orient='index')
    return shops, shops_dict

def make_screenshot(m, img_name, driver):
    m.save("./backend/data_base/map/index.html")
    mapUrl = f"file://{os.getcwd()}/backend/data_base/map/index.html"
    driver.get(mapUrl)
    time.sleep(1)
    driver.save_screenshot(f'./backend/data_base/map/img/{img_name}.png')


driver = webdriver.Firefox(executable_path="./backend/data_base/map/geckodriver",log_path=None)
path = "./backend/data_base/map/shops.csv"
shops_df, shops_dict = preprocessDF(path)
print(shops_df)
uids = [str(user["_id"]) for user in getUser() if isinstance(user["_id"], ObjectId)]


top_k = 2
n_days = 100
for i in trange(n_days):
    for uid in (t:=tqdm(uids)):
        t.set_description("recomending for each user")
        recommended = recommend(uid)
        for shop in recommended[:top_k]:
            shop_id = str(shop[0])
            shops_dict[shop_id]["n_recom"] += 1
    m = show_shops_map(shops_dict, day=i+1)
    make_screenshot(m, f"{i:03d}", driver)

    # break if all shops are recommended
    min_recom = 1
    for shop in shops_dict.values():
        min_recom = min(min_recom, shop["n_recom"])
    if min_recom > 0:
        break

driver.quit()

os.system("ffmpeg -f image2 -r 4.1 -i ./backend/data_base/map/img/%03d.png -vcodec mpeg4 -b 1000k -y ./backend/data_base/map/img/videiko.mp4")
