.PHONY: build

build:
	@docker build -f Hadoop.dockerfile -t raphael/base-hadoop .
	@docker build -f Spark.dockerfile -t raphael/spark .