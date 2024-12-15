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