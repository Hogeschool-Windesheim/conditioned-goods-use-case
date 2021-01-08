#!/bin/bash




#================================================================================================================================================================================================================================================================================

# *** ORDERER SETUP ***
# USE DOCKER-COMPOSE.YAML FILES

#================================================================================================================================================================================================================================================================================

# Downloads the binary files and config files for osnadmin and configtx.yaml
wget https://github.com/hyperledger/fabric/releases/download/v2.3.0/hyperledger-fabric-linux-amd64-2.3.0.tar.gz
tar -xzf hyperledger-fabric-linux-amd64-2.3.0.tar.gz

# We copied the configtx.yaml to the home folder
export FABRIC_CFG_PATH=~/

# configtx.yaml aanpassen volgens: https://hyperledger-fabric.readthedocs.io/en/latest/create_channel/create_channel_participation.html#the-configtx-yaml-file
./configtxgen -profile SampleAppChannelEtcdRaft -outputBlock genesis_block.pb -channelID spark-vebabox-channel

export OSN_TLS_CA_ROOT_CERT=~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/tls/tls-ca-cert.pem
export ADMIN_TLS_SIGN_CERT=~/admin-client/admin-client-tls-cert.pem
export ADMIN_TLS_PRIVATE_KEY=~/admin-client/admin-client-tls-key.pem

./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9440 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY

# Command below dependend on the exports for the variables
./osnadmin channel list -c spark-vebabox-channel -o localhost:9440 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY

export ORDERER_CAFILE=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
export TLS_CERTFILE=/etc/hyperledger/fabric/tls/cert.pem
export ADMIN_TLS_PRIVATE_KEY=/etc/hyperledger/fabric/tls/key.pem

./peer channel join -b /var/hyperledger/production/genesis_block.pb -o fabric-server:9440 --cafile /etc/hyperledger/fabric/tls/tls-ca-cert.pem --certfile /etc/hyperledger/fabric/tls/cert.pem --keyfile /etc/hyperledger/fabric/tls/key.pem