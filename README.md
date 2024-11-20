# Hadoop cluster with Docker

## Specifications

This cluster is set upt with the follow technologies

- Apache Hadoop
- Apache Spark

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