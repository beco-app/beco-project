import pymongo
import json


# Globals
config = json.load(open("./backend/config/config.json"))
db_username = config["db_username"]
db_password = config["db_password"]
db_name = config["db_name"]
db_users = config["db_users"]
db_shops = config["db_shops"]
db_transactions = config["db_transactions"]
db_promotions = config["db_promotions"]
db_active_promotions = config["db_active_promotions"]
db_products = config["db_products"]



mongo = pymongo.MongoClient()
#mongo = pymongo.MongoClient(username=db_username, password=db_password)


def queryFind(db_name, collection_name, query, operation=None, one=False, limit=0):
	mongo_db =  mongo[db_name]
	collections = mongo_db[collection_name]
	if one:
		if operation is None:
			docs = collections.find_one(query)
		else:
			docs = collections.find_one(query, operation)
	else:
		if operation is None:
			if limit > 0:
				docs = collections.find(query).limit(limit)
			else:
				docs = collections.find(query)
		else:
			if limit > 0:
				docs = collections.find(query, operation).limit(limit)
			else:
				docs = collections.find(query, operation)

	return docs

def queryUpdate(db_name, collection_name, query, operation, one=False, array_filters=None):
	mongo_db =  mongo[db_name]
	collections = mongo_db[collection_name]
	if one:
		if array_filters is None:
			docs = collections.update_one(query, operation)
		else:
			docs = collections.update_one(query, operation, array_filters=array_filters)
	else:
		docs = collections.update(query, operation)
	return docs

def queryInsert(db_name, collection_name, document, one=False):
	mongo_db =  mongo[db_name]
	collections = mongo_db[collection_name]
	if one:
		docs = collections.insert_one(document)
	else:
		docs = collections.insert(document)
	return docs

def queryRemove(db_name, collection_name, query, one=False):
	mongo_db =  mongo[db_name]
	collections = mongo_db[collection_name]
	if one:
		#removal = collections.remove_one(query) <- this does not exist
		removal = collections.delete_one(query)
	else:
		removal = collections.delete_many(query)
	return removal


def queryCountDocuments(db_name, collection_name, query, options=None):
	mongo_db = mongo[db_name]
	collections = mongo_db[collection_name]
	if options is not None:
		docs = collections.count_documents(query, options)
	else:
		docs = collections.count_documents(query)
	return docs

def queryAggregate(db_name, collection_name, match, group, sort):
	mongo_db = mongo[db_name]
	collections = mongo_db[collection_name]

	args = [match, group, sort]
	pipeline = [x for x in args if x is not None]
	docs = collections.aggregate(pipeline)
	return docs # CommandCursor
