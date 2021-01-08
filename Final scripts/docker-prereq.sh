#!/bin/bash
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


# *** Docker-engine ***
sudo apt-get remove docker docker-engine docker.io containerd runc -y

sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y



# *** Docker-compose ***
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -a -G docker ${USER}
su - ${USER}