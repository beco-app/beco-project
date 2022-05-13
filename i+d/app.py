import dash
from dash import dcc
from dash import html
import pandas as pd
import numpy as np
from dash.dependencies import Output, Input

###########
# Backend #
###########
import sys
import os
sys.path.append(os.getcwd())

import backend.data_base.tools as tools
from bson.objectid import ObjectId
import random
from datetime import datetime
from sklearn.preprocessing import MultiLabelBinarizer

###########

shopname = 'NULL'

def get_transactions(shop_id, shopname, max_dif_users = 40):
    """
    Simulate new transactions for the given shop
    """

    all_users = tools.getUser()
    all_users = pd.DataFrame(all_users)

    shop_tags = set(tools.getShop(shopname=shopname)[0]["tags"])
    users_mask = [any(p in shop_tags for p in user_pref) for user_pref in all_users.preferences.values]
    available_users = all_users[
        users_mask
    ].sample(max_dif_users, replace=True)

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
        for _ in range(n_users):
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
        new_t_users += available_users._id.sample(n_users_month[month], replace=True).to_list()

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

def get_data(shopname):
    # Sample avocado data
    data = pd.read_csv("https://raw.githubusercontent.com/realpython/materials/master/python-dash/apps/app_4/avocado.csv")
    data["Date"] = pd.to_datetime(data["Date"], format="%Y-%m-%d")
    data.sort_values("Date", inplace=True)
    #print(data.head(5))

    # Get shop_id
    try:
        shop_id = tools.getShop(shopname=shopname)[0]["_id"]
    except Exception as error:
        print(f'Error! Shop {shopname} does not exist in the shops database')
        raise error

    # get the transactions with the shop from the db
    # transactions = tools.getTransaction(shop_id=ObjectId(shop_id))
    # transactions = pd.DataFrame(transactions)
    
    transactions = get_transactions(shop_id, shopname, max_dif_users=40)
    print('Transactions df columns:', transactions.columns)

    users = tools.getUser(_id={"$in": [ObjectId(uid) for uid in transactions.user_id.unique()]})
    users = pd.DataFrame(users)
    users['_id'] = users._id.astype(str)
    users['zip_code'] = users.zip_code.astype(int)
    users['neighbourhood'] = users.neighbourhood.astype(str)
    users['phone'] = users.phone.astype(int)
    users['becoins'] = users.becoins.astype(int)
    users['age'] = (datetime.now() - pd.to_datetime(users.birthday)).dt.total_seconds() // 31536000

    mlb = MultiLabelBinarizer(sparse_output=True)

    users = users.join(
        pd.DataFrame.sparse.from_spmatrix(
            mlb.fit_transform(users.pop('preferences')),
            index=users.index,
            columns=mlb.classes_)
    )

    print('Users df columns:', users.columns)
    #print(transactions.user_id.value_counts())
    return data, transactions, users

def main(shopname):
    data, transactions, users = get_data(shopname)

    external_stylesheets = [
        {
            "href": "https://fonts.googleapis.com/css2?"
            "family=Lato:wght@400;700&display=swap",
            "rel": "stylesheet",
        },
    ]
    app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
    server = app.server
    app.title = "BECO Analytics"

    app.layout = html.Div(
        children=[
            html.Div(
                children=[
                    html.Img(
                        src=app.get_asset_url('logo.png'),
                        width = 70,
                        className="header-image"
                    ),
                    html.H1(
                        children=f"{shopname} analytics", className="header-title"
                    ),
                    html.P(
                        children="Analyze the data of your BECO costumers",
                        className="header-description",
                    ),
                ],
                className="header",
            ),
            html.Div(
                children=[
                    html.Div(
                        children=[
                            html.Div(children="Gender", className="menu-title"),
                            dcc.Dropdown(
                                id="gender-filter",
                                options=[
                                    {"label": gender, "value": gender}
                                    for gender in np.sort(users.gender.unique())
                                ],
                                value=np.sort(users.gender.unique())[0],
                                clearable=False,
                                className="dropdown",
                                multi=True
                            ),
                        ]
                    ),
                    html.Div(
                        children=[
                            html.Div(children="Neighbourhood", className="menu-title"),
                            dcc.Dropdown(
                                id="neighbourhood-filter",
                                options=[
                                    {"label": neighbourhood, "value": neighbourhood}
                                    for neighbourhood in np.sort(
                                        np.append(
                                            ['All neighbourhoods'],
                                             users.neighbourhood.unique()
                                        )
                                    )
                                ],
                                value='All neighbourhoods',
                                clearable=False,
                                searchable=True,
                                className="dropdown",
                                multi=True
                            ),
                        ],
                    ),
                    html.Div(
                        children=[
                            html.Div(
                                children="Date Range", className="menu-title"
                            ),
                            dcc.DatePickerRange(
                                id="date-range",
                                min_date_allowed=transactions.timestamp.min().date(),
                                max_date_allowed=transactions.timestamp.max().date(),
                                start_date=transactions.timestamp.min().date(),
                                end_date=transactions.timestamp.max().date(),
                            ),
                        ]
                    ),
                ],
                className="menu",
            ),
            html.Div(
                children=[
                    html.Div(
                        children=dcc.Graph(
                            id="num_trans_chart",
                            config={"displayModeBar": False},
                        ),
                        className="card",
                    ),
                    html.Div(
                        children=dcc.Graph(
                            id="volume-chart",
                            config={"displayModeBar": False},
                        ),
                        className="card",
                    ),
                ],
                className="wrapper",
            ),
        ]
    )


    @app.callback(
        [Output("num_trans_chart", "figure"), Output("volume-chart", "figure")],
        [
            Input("gender-filter", "value"),
            Input("neighbourhood-filter", "value"),
            Input("date-range", "start_date"),
            Input("date-range", "end_date"),
        ],
    )
    def update_charts(gender, neighbourhood, start_date, end_date):
        neighbourhoods = set(neighbourhood) if type(neighbourhood) != str else {neighbourhood}
        print('neighbourhoods:',neighbourhoods)
        if 'All neighbourhoods' in neighbourhoods:
            users_mask = (
                (users.gender.isin(set(gender)))
            )
        else:
            users_mask = (
                (users.gender.isin(set(gender)))
                & (users.neighbourhood.isin(neighbourhoods))
            )
        filtered_users = users.loc[users_mask, :].copy()
        print('filtered_uers')
        print(filtered_users.head())

        transactions_mask = (
            (transactions.timestamp >= start_date)
            & (transactions.timestamp <= end_date)
            & (transactions.user_id.isin(set(filtered_users._id.unique())))
        )
        filtered_transactions = transactions.loc[transactions_mask, :].copy()
        #filtered_transactions['day'] = filtered_transactions.timestamp.dt.day
        #filtered_transactions['month'] = filtered_transactions.timestamp.dt.month
        filtered_transactions['week'] = filtered_transactions.timestamp.dt.isocalendar().week
        filtered_transactions_gpby = filtered_transactions.groupby('week')
        filtered_transactions['count'] = filtered_transactions_gpby.shop_id.transform(len)
        filtered_transactions = filtered_transactions_gpby.first().sort_values('timestamp').reset_index()

        print('filtered_transactions')
        print(filtered_transactions.head())

        num_trans_chart_figure = {
            "data": [
                {
                    "x": filtered_transactions["timestamp"],
                    "y": filtered_transactions["count"],
                    "type": "lines",
                    "hovertemplate": None, #"%{y} transactions<extra></extra>",
                    "hovermode": "x"
                },
            ],
            "layout": {
                "title": {
                    "text": "Number of Beco Transactions per week",
                    "x": 0.05,
                    "xanchor": "left",
                },
                "xaxis": {"fixedrange": True},
                "yaxis": {"tickprefix": "#", "fixedrange": True},
                "colorway": ["#17B897"],
            },
        }

        #volume_chart_figure = {
        #    "data": [
        #        {
        #            "x": filtered_data["Date"],
        #            "y": filtered_data["Total Volume"],
        #            "type": "lines",
        #        },
        #    ],
        #    "layout": {
        #        "title": {"text": "Avocados Sold", "x": 0.05, "xanchor": "left"},
        #        "xaxis": {"fixedrange": True},
        #        "yaxis": {"fixedrange": True},
        #        "colorway": ["#E12D39"],
        #    },
        #}

        volume_chart_figure = {
            "data": [
                {
                    "x": filtered_transactions["timestamp"],
                    "y": filtered_transactions["count"],
                    "type": "lines",
                    "hovertemplate": "{y} transactions<extra></extra>",
                },
            ],
            "layout": {
                "title": {
                    "text": "Number of Beco Transactions per week",
                    "x": 0.05,
                    "xanchor": "left",
                },
                "xaxis": {"fixedrange": True},
                "yaxis": {"tickprefix": "#", "fixedrange": True},
                "colorway": ["#17B897"],
            },
        }
        
        return num_trans_chart_figure, volume_chart_figure

    app.run_server(debug=True)

if __name__ == "__main__":
    assert len(sys.argv) > 1, "pasame tiendiki broskikiii"
    shopname = sys.argv[1]
    main(shopname)
