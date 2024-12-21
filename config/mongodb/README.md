# MongoDB Replica set with auth mode

Put your keyfile here, so Debezium can monitor your replica set

## Generate it

```bash
sudo openssl rand -base64 756 keyfile
sudo chmod 400 keyfile
```

## Update MongoDB service

On the mongodb service, inside docker-compose.yml, update command to

```yml
command: ["bash", "-c", "chown mongodb:mongodb /data/keyfile && chmod 400 /data/keyfile && mongod --replSet rs0 --bind_ip_all --auth --keyFile /data/keyfile"]
```

## Create the replica set

Enter on Mongo shell

```
mongosh
```

Create your replica set

```
rs.initiate({ _id:"rs0", members : [{ _id: 0, host: "mongodb:27017" }] });
```

## Create a user for debezium on MongoDB

```
admin = db.getSiblingDB("admin")
admin.createUser( { user: "debezium", pwd: "root", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] } )
db.grantRolesToUser('debezium', [{ role: 'root', db: 'admin' }])
```

Finally, fill the property `mongodb.connection.string` on **debezium/mongodb.json** with these credentials

## Authenticate

```
db.getSiblingDB("admin").auth("debezium", passwordPrompt())
```

## Connect with PyMongo

In order for you being able to perform operations on MongoDB with PyMongo inside the container master, your database connection string should look like this

```
mongodb://debezium:root@localhost:27017/?replicaSet=rs0
```