# Cluster for Data Engineering

## Specifications

This cluster is set up via Docker. It uploads the follow technologies as containers

- Apache Hadoop
- Apache Spark
- MongoDB
- PostgreSQL

## How to run

Setting up a hadoop cluster with Docker

```bash
# Download spark and hadoop
bash download.sh

# Build image
docker compose build

# Build image and run containers
docker compose up -d
```
