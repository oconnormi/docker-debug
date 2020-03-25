IMAGE_REGISTRY?=docker.io
IMAGE_NAME?=oconnormi/debug
IMAGE_TAG?=$(shell git rev-parse --verify HEAD)

BUILD_TAG=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Display help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: image
image: ## Build the docker image
	@echo "Building $(BUILD_TAG)"
	@docker build --pull -t $(BUILD_TAG) .

.PHONY: push
push: image ## Push the docker image
	@echo "Pushing $(BUILD_TAG)"
	@docker push $(BUILD_TAG)