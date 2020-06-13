#!/bin/bash

set -eu

# Install ansible
# https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows
sudo apt-get update
sudo apt-get install python-pip libffi-dev libssl-dev -y
pip install ansible pywinrm

