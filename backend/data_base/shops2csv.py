from tools import *
import pandas as pd

def main():
    shops = getShop()
    shops_dict = {
        '_id': [],
        'shopname': [],
        'description': [],
        'timetable': [],
        'web': [],
        'photo': [],
        'location': [],
        'address': [],
        'district': [],
        'neighbourhood': [],
        'zip_code': [],
        'type': [],
        'tags': [],
        'phone': [],
        'product_list': [],
        'nearest_stations': []
    }

    for shop in shops:
        shops_dict["_id"].append(shop["_id"])
        shops_dict["shopname"].append(shop["shopname"])
        shops_dict["description"].append(shop["description"])
        shops_dict["timetable"].append(shop["timetable"])
        shops_dict["web"].append(shop["web"])
        shops_dict["photo"].append(shop["photo"])
        shops_dict["location"].append(shop["location"])
        shops_dict["address"].append(shop["address"])
        shops_dict["district"].append(shop["district"])
        shops_dict["neighbourhood"].append(shop["neighbourhood"])
        shops_dict["zip_code"].append(shop["zip_code"])
        shops_dict["type"].append(shop["type"])
        shops_dict["tags"].append(shop["tags"])
        shops_dict["phone"].append(shop["phone"])
        shops_dict["product_list"].append(shop["product_list"])
        shops_dict["nearest_stations"].append(shop["nearest_stations"])

    df = pd.DataFrame.from_dict(shops_dict)
    df.to_csv("db_shops.csv")


if __name__ == "__main__":
    main()