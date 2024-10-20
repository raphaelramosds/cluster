.PHONY: build

build:
	@docker build -t raphael/base-hadoop ./docker/base
	@docker build -t raphael/master-hadoop ./docker/master
	@docker build -t raphael/worker-hadoop ./docker/worker