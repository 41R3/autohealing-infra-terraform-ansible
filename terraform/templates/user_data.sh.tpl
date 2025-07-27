#!/bin/bash

# Actualizar e instalar dependencias (Amazon Linux 2023)
dnf update -y
dnf install -y git ansible

# Clonar el repo (usa el valor de la variable repo_url)
git clone ${repo_url} /opt/autohealing

# Ir al directorio del playbook
cd /opt/autohealing/ansible

# Ejecutar el playbook en localhost (la misma EC2)
ansible-playbook playbook.yml -i localhost,

