# Hadoop cluster with Docker

## How to run

Setting up a hadoop cluster with Docker

```bash
# Download spark and hadoop
bash download.sh

# Build image
make

# Run containers
docker compose up -d

# Stop containers
docker compose stop
```