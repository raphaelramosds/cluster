# MongoDB

Put your keyfile here, so Debezium can monitor your replica set

## Generate it

```bash
sudo openssl rand -base64 756 keyfile
sudo chmod 400 keyfile
```

## Create the replica set

Enter on Mongo shell

```
mongosh
```

Create your replica set

```
rs.initiate({ _id:"rs0", members : [{ _id: 0, host: "mongodb:27017" }] })
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