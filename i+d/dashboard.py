import numpy as np
import dash
from dash import dcc
from dash import html
import plotly.graph_objects as go
import plotly.express as px
import pandas as pd
import sys
import os

sys.path.append(os.getcwd())

import backend.data_base.tools as tools
from bson.objectid import ObjectId
import random
from datetime import datetime
import calendar


def createApp():
    return dash.Dash()

def create_transactions(shop_id):
    all_users = tools.getUser()
    all_users = pd.DataFrame(all_users)

    # Create random transactions
    n_users_month = {
        1: 5,
        2: 14,
        3: 21,
        4: 39,
        5: 32,
        6: 53,
        7: 49,
        8: 67,
        9: 21,
        10: 12,
        11: 10,
        12: 4
    }
    max_days = {
        1: 31,
        2: 28,
        3: 31,
        4: 30,
        5: 31,
        6: 30,
        7: 31,
        8: 31,
        9: 30,
        10: 31,
        11: 30,
        12: 31
    }
    new_t_timestamps = []
    new_t_users = []
    new_t_payments = []
    new_t_becoins = []
    for month, n_users in n_users_month.items():
        max_day = max_days[month]
        for trans in range(n_users):
            new_t_timestamps.append(
                datetime(
                    2022,                       #year
                    month,                      #month
                    random.randint(1, max_day), #day
                    random.randint(0, 23),      #hour
                    random.randint(0, 59),      #minute
                    random.randint(0, 59),      #second
                    random.randint(0, 59)       #milisecond
                )#.timestamp()
            )
            payment = random.randint(1,10000)/100
            new_t_payments.append(payment)
            becoins = payment//10*100
            new_t_becoins.append(becoins)
        new_t_users += all_users._id.sample(n_users_month[month], replace=True).to_list()

    # eliminate firebase users
    new_t_users = [str(user) if len(str(user)) == 24 else '626ad91ef86a6624c429e3b2' for user in new_t_users]

    # create transactions df
    shop_transactions = pd.DataFrame({
        'shop_id': [shop_id]*len(new_t_users),
        'user_id': new_t_users,
        'timestamp': new_t_timestamps,
        'promotion_used': [None]*len(new_t_users),
        'payment': new_t_payments,
        'becoin_gained': new_t_becoins,
    })
    return shop_transactions


def trans_over_time_fig(transactions, shop_name):
    # Function for creating line chart showing number of transactions over time
    months = transactions.timestamp.dt.month
    transactions['month'] = months

    df = pd.DataFrame(transactions.month.value_counts().sort_index()).reset_index()
    df.columns = ['month', 'num_trans']

    month_abbr = [calendar.month_abbr[x] for x in df.month]
    df['month_abbr'] = month_abbr

    print(df.head(5))

    fig = go.Figure([go.Scatter(x = df['month_abbr'].tolist(), y = df['num_trans'].to_list(),\
                     line = dict(color = 'firebrick', width = 4), name = shop_name)
                     ])
    title = f'Number of BECO transactions over time of {shop_name}'
    fig.update_layout(title = title,
                      xaxis_title = 'Dates',
                      yaxis_title = '# transactions'
                      )
    return fig  


def main(shopname):
    try:
        shop_id = tools.getShop(shopname=shopname)[0]["_id"]
    except Exception as e:
        print(f'Error! Shop {shopname} does not exist in the shops database')
        raise est

    # get the transactions with the shop
    # transactions = tools.getTransaction(shop_id=ObjectId(shop_id))
    # transactions = pd.DataFrame(transactions)
    
    transactions = create_transactions(shop_id)

    # get the users with those transactions
    users = tools.getUser(_id={"$in": [ObjectId(uid) for uid in transactions.user_id.unique()]})
    users = pd.DataFrame(users)
    users['zip_code_int'] = users.zip_code.astype(int)
    users['phone_int'] = users.phone.astype(int)
    users['becoins_int'] = users.becoins.astype(int)
    print(users.columns)
    print(transactions.columns)

    fig = px.scatter(
        users,
        x='phone_int',
        y="zip_code_int",
        size="becoins_int",
        color="gender",
        hover_name="preferences",
        log_x=False,
        size_max=60,
    )

    fig = trans_over_time_fig(transactions, shopname)
    
    app.layout = html.Div([dcc.Graph(id="life-exp-vs-gdp", figure=fig)])
    app.run_server(debug=True)

    
    """
    df = pd.read_csv(
        "https://raw.githubusercontent.com/ThuwarakeshM/geting-started-with-plottly-dash/main/life_expectancy.csv"
    )

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

