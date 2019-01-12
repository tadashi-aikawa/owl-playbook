MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ARGS :=
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9][a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#version := $(shell git rev-parse --abbrev-ref HEAD)

#------

init: ## Init
	@echo Start $@
	@echo End $@

test: ## Test
	@echo Start $@
	@echo End $@

dev: ## Dev
	@echo Start $@
	@echo End $@

run: ## Run
	@echo Start $@
	@echo End $@

