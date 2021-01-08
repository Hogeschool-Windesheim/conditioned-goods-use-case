#!/bin/bash
cd ~/

# Create the folder for peer0-spark
mkdir peer0-spark
cd peer0-spark/

# Downloads the binary files and config files for peer0-spark
wget https://github.com/hyperledger/fabric/releases/download/v2.3.0/hyperledger-fabric-linux-amd64-2.3.0.tar.gz
tar -xzf hyperledger-fabric-linux-amd64-2.3.0.tar.gz
rm hyperledger-fabric-linux-amd64-2.3.0.tar.gz

# *Optional add peer binary file location to path for easy access
echo 'export PATH=~/peer0-spark/bin:$PATH' >> ~/.profile
echo 'export FABRIC_CFG_PATH=~/peer0-spark/config' >> ~/.profile

# *** Docker config ***
# Only use this when using docker containers.
docker pull hyperledger/fabric-peer:amd64-2.3

############################################################

# Setting up CouchDB database
docker pull couchdb:latest
docker run -d --name couchdb-peer0-spark couchdb:latest

############################################################

# Configure the core.yaml of peer
# For info on the config: https://hyperledger-fabric.readthedocs.io/en/latest/deploypeer/peerchecklist.html
mkdir ~/production

sed -i '15s\.*\     id: peer0-spark\' core.yaml # peer.id
sed -i '19s\.*\     networkId: test\' core.yaml # peer.networkId
sed -i '23s\.*\     listenAddress: localhost:7061\' core.yaml # peer.listenAddress
sed -i '28s\.*\     chaincodeListenAddress: localhost:7062\' core.yaml # peer.chaincodeListenAddress
sed -i '36s\.*\     chaincodeAddress: localhost:7062\' core.yaml # peer.chaincodeAddress
sed -i '42s\.*\     address: localhost:7061\' core.yaml # peer.address
sed -i '89s\.*\         bootstrap: 127.0.0.1:7071'\ core.yaml # endpoints.bootstrap
sed -i '116s\.*\         endpoint:localhost:7061'\ core.yaml # endpoints.endpoint
sed -i '170s\.*\         externalEndpoint:localhost:7061'\ core.yaml # endpoints.externalEndpoint

# TLS config
sed -i '255s\.*\         enabled:  true'\ core.yaml # tls.enabled
sed -i '262s\.*\             file: ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/cert.pem'\ core.yaml # cert.file
sed -i '265s\.*\             file: ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/key.pem'\ core.yaml # key.file
sed -i '271s\.*\             file:'\ core.yaml # rootcert.file

sed -i '724s\.*\         clientAuthRequired: true\' core.yaml # clientAuthRequired
sed -i '728s\.*\             files: [~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/tls-ca-cert.pem]\' core.yaml # clientAuthRequired

# MSP config
sed -i '298s\.*\     fileSystemPath: ~/production\' core.yaml # peer.fileSystemPath --> default value: /var/hyperledger/production
sed -i '327s\.*\     mspConfigPath: ~/organizations/peerOrganizations/spark/peers/peer0-spark/msp\' core.yaml # peer.mspConfigPath
sed -i '336s\.*\     localMspId: spark\' core.yaml # peer.localMspId


# Database config
sed -i '621s\.*\     stateDatabase: CouchDB\' core.yaml # ledger.state.stateDatabase
sed -i '629s\.*\        couchDBAddress: 127.0.0.1:5984\' core.yaml # ledger.state.couchDBConfig.couchDBAddress
sed -i '631s\.*\        username:\' core.yaml # ledger.state.couchDBConfig.username
sed -i '636s\.*\        password:\' core.yaml # ledger.state.couchDBConfig.password
sed -i '697s\.*\     rootDir: ~/production/snapshots\' core.yaml # ledger.snapshots.rootDir

# Operation server monitoring config *optional
sed -i '706s\.*\     listenAddress: 127.0.0.1:9443\' core.yaml # operations.listenAddress
sed -i '711s\.*\         enabled: true\' core.yaml # operations.tls.enabled
sed -i '715s\.*\             file:\' core.yaml # operations.tls.cert.file --> can be the same as peer.tls.cert.file
sed -i '719s\.*\             file:\' core.yaml # operations.tls.key.file --> can be the same as peer.tls.key.file
sed -i '724s\.*\         clientAuthRequired: true\' core.yaml # operations.clientAuthRequired

# Metrics monitoring config *optional
sed -i '737s\.*\     provider: disabled\' core.yaml # metrics.provider
sed -i '745s\.*\         address: 127.0.0.1:8125\' core.yaml # metrics.address
