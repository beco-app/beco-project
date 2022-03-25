import requests
import json
import hashlib

# Globals
#directory = "./test/examples/"

"""
def loadJSON(json_name):
	with open(directory + json_name, 'r') as f:
		json_file = json.load(f)
	return json_file
"""

def test():
	response = requests.get("http://127.0.0.1:5000/")
	assert(response.status_code == 200)


	response = requests.get()

if __name__ == '__main__':
	test()