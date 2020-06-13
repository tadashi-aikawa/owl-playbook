#!/bin/bash

set -eu

# Install ansible
# https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows
sudo apt-get update
sudo apt-get install python3-pip libffi-dev libssl-dev -y
pip3 install ansible pywinrm
