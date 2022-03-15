import sys
# sys.path.append("/home/ubuntu/beco-project/backend")
print(sys.version)
from data_base import tools


from flask import Flask
app = Flask(__name__)

# Test
@app.route('/')
def hello_world():
    return 'Hello from Flask!'

import os

@app.route('/dbfetch_test')
def getfromDB():
    return str(tools.getUser()[0])

if __name__ == '__main__':
    app.run()