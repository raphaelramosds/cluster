.PHONY: build

hadoop:
	@docker build -f Dockerfile.hadoop -t raphael/base-hadoop .

spark:
	@docker build -f Dockerfile.spark -t raphael/base-spark .