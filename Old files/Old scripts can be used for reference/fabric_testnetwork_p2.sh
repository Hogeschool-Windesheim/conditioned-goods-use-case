#!/bin/bash

# Part 2 of prereq1.sh
# and needs to be run as ./prereq2.sh

cd ~/Downloads/

# Remove downloads
#rm -rf fabric-samples/ go1.15.3.linux-amd64.tar.gz

# Run script from: https://bit.ly/2ysbOFE
sudo curl -sSL https://bit.ly/2ysbOFE | bash -s

# If you want a specific release, pass a version identifier for Fabric and Fabric-CA docker
# images. The command below demonstrates how to download the latest production releases -
# Fabric v2.2.1 and Fabric CA v1.4.9

# curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.1 1.4.9


# Adding to the PATH variable
# cd
echo 'export PATH=~/fabric-samples/bin:$PATH' >> ~/.profile
source ~/.profile


# Bring up the test network
cd fabric-samples/test-network

./network.sh down
./network.sh up

# List docker containers that are running on your machine
docker ps -a


# Creating a channel
./network.sh createChannel

# Deploy the chaincode
./network.sh deployCC

# Add to PATH
echo 'export PATH='${PWD}'/../bin:$PATH' >> ~/.profile
source ~/.profile

echo 'export FABRIC_CFG_PATH='$PWD'/../config/' >> ~/.profile

echo 'export CORE_PEER_TLS_ENABLED=true' >> ~/.profile
echo 'export CORE_PEER_LOCALMSPID="Org1MSP"' >> ~/.profile
echo 'export CORE_PEER_TLS_ROOTCERT_FILE='${PWD}'/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt' >> ~/.profile
echo 'export CORE_PEER_MSPCONFIGPATH='${PWD}'/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp' >> ~/.profile
echo 'export CORE_PEER_ADDRESS=localhost:7051' >> ~/.profile
source ~/.profile

peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'
source ~/.profile


# Query to pull data from chain
# When not working, try 'source ~/.profile' again
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'