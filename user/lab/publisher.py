from pymongo import MongoClient

mongo_port = 27017
mongo_host = 'localhost'
mongo_uri = f"mongodb://{mongo_host}:{mongo_port}/?replicaSet=rs0"
mongo_db = 'engdados'

client = MongoClient(mongo_uri)
db = client[mongo_db]
alunos = db.alunos

alunos.insert_one({
    "nome" : "Raphael Ramos",
    "idade" : 23,
})