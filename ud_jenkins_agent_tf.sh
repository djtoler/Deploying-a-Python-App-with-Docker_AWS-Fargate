#!/bin/bash

sudo apt update
sudo apt install build-essential 
sudo apt install -y default-jre
sudo apt-get install pkg-config
#c
sudo apt install libmysqlclient-dev -y

curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-python.sh
chmod +x auto-python.sh
./auto-python.sh
sudo apt install -y python3.7-dev

curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-terraform.sh
chmod +x auto-terraform.sh
./auto-terraform.sh