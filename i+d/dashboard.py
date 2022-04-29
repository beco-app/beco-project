import numpy as np
import dash
from dash import dcc
from dash import html
import plotly.express as px
import pandas as pd
import sys
import os
sys.path.append(os.getcwd())
import backend.data_base.tools as tools
from bson.objectid import ObjectId
import random
import datetime

def createApp():
    return dash.Dash()

def main(shopname):

    df = pd.read_csv(
        "https://raw.githubusercontent.com/ThuwarakeshM/geting-started-with-plottly-dash/main/life_expectancy.csv"
    )

    shop_id = tools.getShop(shopname=shopname)[0]["_id"]
    print(shop_id)
    transactions = tools.getTransaction(shop_id=ObjectId(shop_id))
    transactions = pd.DataFrame(transactions)

    users = tools.getUser(_id={"$in": [ObjectId(uid) for uid in transactions.user_id.unique()]})
    users = pd.DataFrame(users)

    all_users = tools.getUser()
    all_users = pd.DataFrame(all_users)

    # Create random transactions
    n_users_month = {
        "jan": 5,
        "feb": 14,
        "mar": 21,
        "apr": 39,
        "may": 32,
        "jun": 53,
        "jul": 49,
        "aug": 67,
        "sep": 21,
        "oct": 12,
        "nov": 10,
        "dec": 4
    }
    datetimes = []
    for month, n_users in enumerate(n_users_month.values()):
        for trans in range(n_users):
            datetimes.append(datetime(2022, month, random.randint(1,30), random.randint(0,59), random.randint(0,59)))


    # Now populate the transactions db

    print(all_users._id.sample(n_users_month[month], replace=True))

    """
    fig = px.scatter(
        df,
        x="GDP",
        y="Life expectancy",
        size="Population",
        color="continent",
        hover_name="Country",
        log_x=True,
        size_max=60,
    )
    """


if __name__ == "__main__":
    assert len(sys.argv) > 1, "pasame tiendiki broskikiii"
    shopname = sys.argv[1]
    app = createApp()
    main(shopname)
    # app.layout = html.Div([dcc.Graph(id="life-exp-vs-gdp", figure=fig)])
    app.run_server(debug=True)
