#!/bin/bash
# Instalar dependencias
dnf update -y
dnf install -y git python3
pip3 install ansible

# Clonar repo
git clone ${repo_url} /tmp/autohealing

# Ejecutar Ansible
cd /tmp/autohealing/ansible
ansible-playbook playbook.yml
