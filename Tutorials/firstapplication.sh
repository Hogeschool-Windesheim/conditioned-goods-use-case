#!/bin/bash

# Install Python
sudo apt-get update

sudo apt-get install python3.8

# Install Make
sudo apt-get install ubuntu-make -y

#Install essentials / GCC
sudo apt install build-essential

#LAUNCH NETWORK
cd Downloads/fabric-samples/test-network

# Network down
./network.sh down

# Start test network
./network.sh up createChannel -c mychannel -ca

# Deploy Chaincode
./network.sh deployCC -ccn basic -ccl javascript

# Install packages
cd ../asset-transfer-basic/application-javascript

npm install

# Run application and enroll Admin user
node app.js