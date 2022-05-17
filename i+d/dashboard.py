from inspect import trace
from termios import TAB1
import dash
from dash import dcc
from dash import html
import pandas as pd
import numpy as np
from dash.dependencies import Output, Input
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots


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

def get_transactions(shop_id, shopname, max_dif_users):
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
        9: 31,
        10: 18,
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

def get_data(shopname, max_dif_users):
    # Get shop_id
    try:
        shop_id = tools.getShop(shopname=shopname)[0]["_id"]
    except Exception as error:
        print(f'Error! Shop {shopname} does not exist in the shops database')
        raise error

    # get the transactions with the shop from the db
    # transactions = tools.getTransaction(shop_id=ObjectId(shop_id))
    # transactions = pd.DataFrame(transactions)
    
    transactions = get_transactions(shop_id, shopname, max_dif_users=max_dif_users)
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
    # print(transactions.user_id.value_counts())
    return transactions, users, shop_id

def get_filtered_data(users, transactions, gender, neighbourhood, start_date, end_date):
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
    print('filtered_users')
    print(filtered_users.head())

    transactions_mask = (
        (transactions.timestamp >= start_date)
        & (transactions.timestamp <= end_date)
        & (transactions.user_id.isin(set(filtered_users._id.unique())))
    )
    filtered_transactions = transactions.loc[transactions_mask, :].copy()
    filtered_transactions['day'] = filtered_transactions.timestamp.dt.day
    filtered_transactions['month'] = filtered_transactions.timestamp.dt.month
    filtered_transactions['week'] = filtered_transactions.timestamp.dt.isocalendar().week

    print('filtered_transactions')
    print(filtered_transactions.head())
    return filtered_users, filtered_transactions

def get_num_trans_and_facturation_chart_fig(filtered_transactions, tab):
    transactions = filtered_transactions.copy()
    transactions_gpby = transactions.groupby('week')
    transactions['trans_count'] = transactions_gpby.shop_id.transform(len)
    transactions = transactions_gpby.first().sort_values('timestamp').reset_index()
    facturations = []
    for i, (k,gp) in enumerate(transactions_gpby):
        facturations.append(np.round(gp.payment.sum(),2))
    transactions['facturation'] = facturations

    #print(transactions[['week','trans_count','facturation']])

    fig = make_subplots(specs=[[{"secondary_y": True}]])

    if tab == "transactions":
        fig.add_trace(
            go.Scatter(
                x = transactions['timestamp'].values,
                y = transactions['trans_count'].values,
                name = 'Number of transactions per week',
            ),
            secondary_y = True
        )

        fig.update_layout(title_text="Number of transactions per week")
        fig.update_yaxes(
            title_text = "# Transactions", 
            secondary_y = True
        )

    elif tab == 'facturation':
        fig.add_trace(
            go.Scatter(
                x = transactions['timestamp'].values,
                y = transactions['facturation'].values,
                name = 'Facturation per week',
            ),
            secondary_y = False
        )
        fig.update_layout(title_text="Facturation per week")
        fig.update_yaxes(
            title_text = "Facturation (€)", 
            secondary_y = False
        )

    fig.update_xaxes(title_text="Date")

    return fig

def get_competence_chart_figure(users, shop_id):
    users_transactions = pd.DataFrame()
    for user in users._id.values:
        user_transactions = pd.DataFrame(tools.getTransaction(user_id=ObjectId(user)))
        users_transactions = pd.concat([users_transactions, user_transactions])

    # Remove transactions from the analyzed shop
    # s1 = users_transactions.shape
    if not 'shop_id' in users_transactions.columns:
        raise "There is no data to plot"

    users_transactions = users_transactions[users_transactions.shop_id != str(shop_id)]
    # s2 = users_transactions.shape
    # print("Other shops users transactions shapes:",s1,s2)

    shop_tags = set(tools.getShop(_id=ObjectId(shop_id))[0]["tags"])

    shops_names = []
    is_competence = []
    for shop in users_transactions.shop_id.values:
        shop = tools.getShop(_id=ObjectId(shop))[0]
        shops_names.append(shop["shopname"])
        tags = shop["tags"]
        if any(tag in shop_tags for tag in tags):
           is_competence.append(True)
        else:
            is_competence.append(False)

    users_transactions['shop_name'] = shops_names
    users_transactions['is_competence'] = is_competence
    users_transactions = users_transactions[users_transactions.is_competence == True]
    
    users_transactions_gpb = users_transactions.groupby('shop_id')
    users_transactions['count'] = users_transactions_gpb._id.transform(len)
    users_transactions = (
        users_transactions_gpb
        .first()
        .sort_values(['count','shop_name'], ascending=[False,True])
        .reset_index()
    )

    fig = px.bar(
        users_transactions,
        y='count',
        x='shop_name',
        title="Number of transactions of your customers on the competence shops"
    )
    fig.update_traces(textfont_size=12, textangle=0, textposition="outside")
    fig.update_layout(xaxis_tickangle=90)

    fig.update_xaxes(title_text='Shop name')
    fig.update_yaxes(title_text='# Transactions')

    return fig
   
def get_polar_plots_figures(filtered_users):
    """Pie chart age distribution and Polar chart with users preferences"""
    fig = make_subplots(
        rows=1, cols=2,
        specs=[[{'type': 'domain'}, {'type': 'polar'}]],
        subplot_titles=['Users age distribution', 'Users preferences']
    )
    preferences_tags = [
        'Accessible', 'Allows pets', 'Bakery', 'Bar', 'Beverages', 'Cosmetics',
        'For children', 'Fruits & vegetables', 'Green space', 'Herbalist',
        'Local products', 'Pharmacy', 'Plastic free', 'Recycled material',
        'Restaurant', 'Second hand', 'Supermarket', 'Vegan food'
    ]
    users = filtered_users.copy()
    users_tags = users[preferences_tags].sum(axis=0)
    users_tags = users_tags/len(users)
    users_tags *= 100

    binned_ages = []
    for age in users.age.values:
        if age <= 20:
            binned_ages.append('12-20')
        elif age <= 35:
            binned_ages.append('21-35')
        elif age <= 50:
            binned_ages.append('36-50')
        elif age <= 65:
            binned_ages.append('51-65')
        else:
            binned_ages.append('66+')

    users['bin_age'] = binned_ages       
    users_gpby_age = users.groupby('bin_age')
    users['age_count'] = users_gpby_age._id.transform(len)
    users = users_gpby_age.first().sort_values('bin_age').reset_index()
    users['age_percentage'] = users.age_count/users.age_count.sum()
    print(users[['bin_age','age_percentage']])

    fig.add_trace(
        go.Pie(
            labels = users.bin_age,
            values = users.age_percentage,
            name = "Users age distribution",
            hole = 0.3,
            textinfo = 'label+percent',
            insidetextorientation='radial'
        ),
        1, 1
    )
    
    fig.add_trace(
        go.Scatterpolar(
            name = "Users preferences (in %)",
            theta = users_tags.index,
            r = users_tags.values,
            fill='toself'
        ),
        1, 2
    )

    fig.update_layout(
        polar2 = dict(
            radialaxis = dict(
                angle = 180,
                tickangle = -180 # so that tick labels are not upside down
            )
        )
    )

    fig.layout.annotations[0].update(y=1.15)
    fig.layout.annotations[1].update(y=1.15)

    return fig          

def get_new_users_fig(filtered_transactions):
    "stacked bar chart comparant el % o nombre d'usuaris nous mensuals vs els que repeteixen"
    print("Unique users in transactions:", len(filtered_transactions.user_id.unique()))
    transactions = filtered_transactions.copy()
    new_users_idx = transactions.drop_duplicates(subset='user_id').index.values
    transactions['user_first_time'] = 0
    transactions.loc[new_users_idx, 'user_first_time'] = 1
    transactions_all_gpb = transactions.groupby('month')
    transactions_first_users_gpb = transactions[transactions.user_first_time == 1].groupby('month')
    transactions_non_first_users_gpb = transactions[transactions.user_first_time == 0].groupby('month')
    transactions['first time users'] = transactions_first_users_gpb.user_id.transform(len)
    transactions['not first time users'] = transactions_non_first_users_gpb.user_id.transform(len)
    transactions = transactions_all_gpb.first().sort_values('timestamp').reset_index()
    transactions.fillna(0, inplace=True)

    fig = px.bar(
        transactions,
        x = 'month',
        y = ['first time users', 'not first time users'],
        title = 'Number of transactions per month by user type'
    )

    fig.update_xaxes(title_text="Month")
    fig.update_yaxes(title_text="# Transactions")

    return fig


def get_data_table(users, transactions):

    table = dash.dash_table.DataTable(
        data=transactions.to_dict('rows'),
        columns=[{"id": x, "name": x} for x in transactions.columns],
        style_as_list_view = True,
        export_format='xlsx',
        export_headers='display',             
    )
    return html.Div(table)

def main(shopname):
    transactions, users, shop_id = get_data(shopname, max_dif_users=60)

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
                                value=[i for i in np.sort(users.gender.unique())],
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
                        [
                            dcc.Tabs(
                                id='tabs-1', value='facturation',
                                children=[
                                    dcc.Tab(label='Facturation', value='facturation'),
                                    dcc.Tab(label='Number of transactions', value='transactions'),

                                ]
                            ),
                            html.Div(
                                children=dcc.Graph(
                                    id='num_trans_facturation-charts',
                                    config={"displayModeBar": False}
                                ),
                            )
                        ],
                        className="card",
                    ),
                    html.Div(
                        children=dcc.Graph(
                            id="new_users-chart",
                            config={"displayModeBar": False},
                        ),
                        className="card",
                    ),
                    html.Div(
                        children=dcc.Graph(
                            id="users_polar-chart",
                            config={"displayModeBar": False},
                        ),
                        className="card",
                    ),
                    html.Div(
                        children=dcc.Graph(
                            id="competence-chart",
                            config={"displayModeBar": False},
                        ),
                        className="card",
                    ),
                    # html.Div(
                    #     id='data_table',
                    #     className="card"
                    # )
                ],
                className="wrapper",
            ),
        ]
    )


    @app.callback(
        [
            Output("num_trans_facturation-charts", "figure"),
            Output("competence-chart", "figure"),
            Output("users_polar-chart", "figure"),
            Output("new_users-chart", "figure"),
            #Output("data_table", "children")
        ],
        [
            Input("gender-filter", "value"),
            Input("neighbourhood-filter", "value"),
            Input("date-range", "start_date"),
            Input("date-range", "end_date"),
            Input('tabs-1', "value")
        ],
    )
    def update_charts(gender, neighbourhood, start_date, end_date, tab1):
        filtered_users, filtered_transactions = get_filtered_data(users, transactions, gender, neighbourhood, start_date, end_date)

        num_trans_and_facturation_chart_fig = get_num_trans_and_facturation_chart_fig(filtered_transactions, tab1)
        competence_chart_fig = get_competence_chart_figure(filtered_users, shop_id)
        users_polar_figs = get_polar_plots_figures(filtered_users)
        new_users_fig = get_new_users_fig(filtered_transactions)
        data_table = get_data_table(filtered_users, filtered_transactions)
        return num_trans_and_facturation_chart_fig, competence_chart_fig, users_polar_figs, new_users_fig#, data_table

    app.run_server(debug=True)

if __name__ == "__main__":
    assert len(sys.argv) > 1, "A valid store name must be passed as argument"
    shopname = sys.argv[1]
    print(f"Starting {shopname} dashboard...")
    main(shopname)