#!/bin/bash

# More info on: https://hyperledger-fabric-ca.readthedocs.io/en/latest/users-guide.html#configuration-settings

#docker container stop containerid
#docker container rm 

sudo apt install libtool libltdl-dev

go get -u github.com/hyperledger/fabric-ca/cmd/fabric-ca-server
go get -u github.com/hyperledger/fabric-ca/cmd/fabric-ca-client

./fabric-ca-server init -b admin:adminpw
./fabric-ca-server start -b admin:adminpw

#SECURITY WARNING: The Fabric CA server should always be started with TLS enabled (tls.enabled set to true). Failure to do so leaves the server vulnerable to an attacker with access to network traffic.

echo 'export FABRIC_CA_HOME=$HOME/fabric-ca/server' >> ~/.profile
echo 'export FABRIC_CA_CLIENT_HOME=$HOME/fabric-ca/clients/admin' >> ~/.profile
source ~/.profile

./fabric-ca-client enroll -u http://admin:adminpw@localhost:7054

# To create multiple identities: https://hyperledger-fabric-ca.readthedocs.io/en/latest/users-guide.html#registering-a-new-identity

fabric-ca-client register --id.name admin2 --id.affiliation org1.department1 --id.attrs 'hf.Revoker=true,admin=true:ecert'
QurlGkVdeHhM