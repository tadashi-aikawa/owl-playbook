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

run-home: ## Run vm-gui (home)
	@ansible-playbook -K --extra-vars "env=home" -i local ubuntu-gui.yml

run-office: ## Run vm-gui (office)
	@ansible-playbook -K --extra-vars "env=office" -i local ubuntu-gui.yml

run-home-tmp: ## Run vm-gui with only tmp tags (home)
	@ansible-playbook -K --extra-vars "env=home" --tags tmp -i local ubuntu-gui.yml

run-office-tmp: ## Run vm-gui with only tmp tags (office)
	@ansible-playbook -K --extra-vars "env=office" --tags tmp -i local ubuntu-gui.yml

