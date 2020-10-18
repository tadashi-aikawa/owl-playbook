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

lubuntu-jp: ## Run lubuntu-jp
	@ansible-playbook -K -i local lubuntu-jp.yml

ubuntu: ## Run ubuntu
	@ansible-playbook -K -i local ubuntu.yml

wsl-ubuntu: ## Run ubuntu for WSL
	@ansible-playbook -i local wsl-ubuntu.yml --extra-vars="@.secret/local.yaml"

lubuntu-jp-tmp: ## Run lubuntu-jp with only tmp tags
	@ansible-playbook -K --tags tmp -i local lubuntu-jp.yml

ubuntu-tmp: ## Run ubuntu with only tmp tags
	@ansible-playbook -K --tags tmp -i local ubuntu.yml

wsl-ubuntu-tmp: ## Run ubuntu for WSL with only tmp tags
	@ansible-playbook --tags tmp -i local wsl-ubuntu.yml  --extra-vars="@.secret/local.yaml"

