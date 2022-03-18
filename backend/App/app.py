import sys
import os
from data_base import tools

import firebase_admin
import pyrebase
import json
from firebase_admin import credentials, auth
from flask import Flask, request
from functools import wraps

# App configuration
app = Flask(__name__)

# Connect to firebase
cred = credentials.Certificate('backend/App/fbAdminConfig.json')
firebase = firebase_admin.initialize_app(cred)
pb = pyrebase.initialize_app(json.load(open('backend/App/fbconfig.json')))

# Data source
users = [{'uid': 1, 'name': 'Yikai Qiu'}]


def check_token(f):
    @wraps(f)
    def wrap(*args,**kwargs):
        if not request.headers.get('authorization'):
            return {'message': 'No token provided'},400
        try:
            user = auth.verify_id_token(request.headers['authorization'])
            request.user = user
        except:
            return {'message':'Invalid token provided.'},400
        return f(*args, **kwargs)
    return wrap


# Test
@app.route('/')
def hello_world():
    return 'Hello from Flask!'

# Api route to get users
@app.route('/api/userinfo')
@check_token
def userinfo():
    return {'data': users}, 200

# Api route to sign up a new user
@app.route('/api/signup')
def signup():
    email = request.form.get('email')
    password = request.form.get('password')

    if email is None or password is None:
        return {'message': 'Error missing email or password'},400
    try:
        user = auth.create_user(
            email=email,
            password=password
        )
        return {'message': f'Successfully created user {user.uid}'},200
    except:
        return {'message': 'Invalid email or password'},400

# Api route to get a new token for a valid user
@app.route('/api/token')
def token():
    email = request.form.get('email')
    password = request.form.get('password')
    try:
        user = pb.auth().sign_in_with_email_and_password(email, password)
        jwt = user['idToken']
        return {'token': jwt}, 200
    except:
        return {'message': 'There was an error logging in'},400


# Write user to database
@app.route('/api/register_user')
def register_user():
    """
        Register new user to the database, which also has been previously added to firest
    """
    username = request.form.get('username')
    becoins = 0
    try:
        # Afegir 
        return {'message': 'Error'}, 400
    except:
        return {'message': 'Error'}, 400


# Get info from username
@app.route('/user_info/<username>')
def get_user(username):
    usr = tools.getUser(username=username)
    if not usr:
        return {'message': 'User not found'}, 404
    else:
        return str(usr)

# Get recommended shops
@app.route('/recommended/<username>')
def recommended_shops(username):
    return 0

# Get nearest shops
@app.route('/nearest_shops/<username>/<lat>/<long>/<distance>')
def recommended_shops(username, lat, long, distance):
    return 0


if __name__ == '__main__':
    app.run(debug=True)