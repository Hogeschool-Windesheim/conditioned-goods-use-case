#!/bin/bash

# This script is meant for a fresh install of ubuntu
# and needs to be run as ./prereq1.sh

sudo apt update
sudo apt upgrade -y

# SSH install
sudo apt install openssh-server -y
sudo ufw allow ssh

# Git install
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update
sudo apt install git -y


# Curl install
sudo apt install curl -y

# Install go
cd Downloads/
sudo wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile

# Docker install
sudo apt remove docker docker-engine docker.io
sudo apt install docker.io docker-compose -y

sudo systemctl start docker
sudo systemctl enable docker

# add user ubuntu to the docker group
sudo usermod -a -G docker ${USER}
su - ${USER}