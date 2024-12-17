# Cluster for Data Engineering

## Specifications

This cluster is set up via Docker. It uploads the follow technologies as containers

- Apache Hadoop
- Apache Spark
- Apache Kafka
- MongoDB
- PostgreSQL

## How to run

Setting up a hadoop cluster with Docker

```bash
# Download some dependencies
bash download.sh

# Build image
docker compose build

# Build image and run containers
docker compose up -d
```

## Note

Although everything is going to work, this cluster is not ready to be published on a production enviroment due to security reasons. And I'm not proud of this. So here some things to do in order to make it more security

- Once the cluster is up, you should follow the steps on [MongoDB Replica set with auth mode](./config/mongodb/README.md) so Debezium can **safely** monitor MongoDB collections.

## References

- [How to setup a replica set on MongoDB](https://www.mongodb.com/docs/v6.2/tutorial/deploy-replica-set-with-keyfile-access-control/)