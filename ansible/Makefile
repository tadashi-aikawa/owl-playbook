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

#------

run: ## Run vm-gui
	@echo Start $@
	@ansible-playbook -K --extra-vars "env=vm-gui" -i local site.yml
	@echo End $@

run-tmp: ## Run vm-gui with only tmp tags
	@echo Start $@
	@ansible-playbook -K --extra-vars "env=vm-gui" --tags tmp -i local site.yml
	@echo End $@

