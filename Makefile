.PHONY: build

build:
	@docker build -t raphael/base-hadoop:2.4.6 ./docker/base
	@docker build -t raphael/master-hadoop:2.4.6 ./docker/master
	@docker build -t raphael/worker-hadoop:2.4.6 ./docker/worker