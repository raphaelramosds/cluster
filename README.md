# Cluster for Data Engineering

## Specifications

This cluster is set up via Docker. It uploads the follow technologies as containers

- Apache Hadoop
- Apache Spark
- Apache Kafka
- MongoDB
- PostgreSQL

> Learn [How to setup a replica set on MongoDB](https://www.mongodb.com/docs/v6.2/tutorial/deploy-replica-set-with-keyfile-access-control/), so Debezium can monitor MongoDB collections.

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
