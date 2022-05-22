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

"""
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
    """
def show_shops_map(shops, my_map=None, day=0):
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
            color = 'blue' if shop["n_recom"] > 0 else 'red',
            fill_opacity = 0.9 if shop["n_recom"] > 0 else 0.5,
            radius= 3 if shop["n_recom"] > 0 else 7, #(shop["n_recom"]**0.5716)*1.2, #formula per matenir proporcions visuals humanes
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
    
    item_txt = """<br> &nbsp; <i class="fa fa-circle-o" style="color:{col}"></i> {item} &nbsp;"""
    html_itms = item_txt.format( item= "Not recommended" , col= "red") + item_txt.format( item= "Recommended" , col= "blue")

    legend_html = """
         <div style="
         position: fixed; 
         top: 200px; left: 200px; width: 175px; height: 80px; 
         border:2px solid grey; z-index:9999; 

         background-color:white;
         opacity: .85;

         font-size:14px;
         font-weight: bold;

         ">
         &nbsp; {title} 

         {itm_txt}

          </div> """.format( title = "LEGEND", itm_txt= html_itms)
    mymap.get_root().html.add_child(folium.Element( legend_html ))

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
    m.save("/Users/tomas.gadea/Desktop/beco_csvs/index.html")
    mapUrl = f"file:///Users/tomas.gadea/Desktop/beco_csvs/index.html"
    driver.get(mapUrl)
    time.sleep(1)
    driver.save_screenshot(f'/Users/tomas.gadea/Desktop/beco_csvs/img/{img_name}.png')


driver = webdriver.Firefox(executable_path="./backend/data_base/map/geckodriver",log_path=None)
uids = [str(user["_id"]) for user in getUser() if isinstance(user["_id"], ObjectId)]


ndays = 1000
for topk in [1]:
    shops_df, shops_dict = preprocessDF("./backend/data_base/map/shops.csv")
    m = show_shops_map(shops_dict, day=0)
    make_screenshot(m, f"u100-top{topk:02d}/{0:03d}", driver)
    total_days = 0
    for i in trange(ndays):
        total_days = i+1
        for uid in (t:=tqdm(uids)):
            t.set_description("recomending for each user")
            recommended = recommend(uid)
            for shop in recommended[:topk]:
                shop_id = str(shop[0])
                shops_dict[shop_id]["n_recom"] += 1
        m = show_shops_map(shops_dict, day=i+1)
        make_screenshot(m, f"u100-top{topk:02d}/{i+1:03d}", driver)

        # break if all shops are recommended
        min_recom = 1
        n_recommended = 0
        for shop in shops_dict.values():
            if shop["n_recom"] > 0:
                n_recommended += 1
            min_recom = min(min_recom, shop["n_recom"])
        print(f"{n_recommended}/{len(shops_dict)} shops recommended")
        if min_recom > 0:
            break
    print(f"Total days top{topk:02d} = {total_days}")
    os.system(f"ffmpeg -f image2 -r 4.1 -i /Users/tomas.gadea/Desktop/beco_csvs/img/u100-top{topk:02d}/%03d.png -vcodec mpeg4 -b 1000k -y /Users/tomas.gadea/Desktop/beco_csvs/img/videiko.mp4")
driver.quit()
