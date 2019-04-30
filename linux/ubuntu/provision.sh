#!/bin/bash

set -eu

# Install ansible
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-18-04

apt -y update
apt -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt -y update
apt -y install ansible

chmod 600 .ssh/*
