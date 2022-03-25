import sys
sys.path.insert(0, '/var/www/html/flaskapp')
sys.path.insert(0, "/home/ubuntu/beco-project/backend")
sys.path.insert(0, "/home/ubuntu/beco-project/backend/data_base")
sys.path.insert(0, "/home/ubuntu/beco-project/backend/App/.env/lib/python3.8/site-packages")

import os
os.chdir("/home/ubuntu/beco-project/")

from app import app as application
