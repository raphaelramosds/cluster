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

**NOTE.** Once the cluster is up, you must follow the steps described [here](./config/mongodb/README.md) so Debezium can monitor MongoDB collections. Skip this if you don't mind MongoDB being restart over and over again.

## References

- [How to setup a replica set on MongoDB](https://www.mongodb.com/docs/v6.2/tutorial/deploy-replica-set-with-keyfile-access-control/)