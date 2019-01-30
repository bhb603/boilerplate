NAME := hey
TAG := $(shell git describe --long --match="v[0-9]*.[0-9]*.[0-9]*" --always)

.PHONY: tag build

tag:
	@echo $(TAG)

build:
	docker build -t $(NAME):latest .
	docker tag $(NAME):latest $(NAME):$(TAG)
