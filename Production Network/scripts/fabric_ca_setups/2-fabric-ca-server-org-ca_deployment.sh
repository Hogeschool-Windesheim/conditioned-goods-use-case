#!/bin/bash

# RCA-CA name: Spark!LivingLab-CA
# Default port: 7055

# RCA-admin credentials:
#	username: rca-admin
#	password: rca-Welkom01!

# Default directory: ~/fabric-ca-server-org1

# *** DEPLOYING THE ORGANIZATION CA ***
# Info: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#deploy-an-organization-ca

# Creating folder and copying binary file (fabric-ca-server) to folder fabric-ca-server-org1
cd
mkdir fabric-ca-server-org1
cp Downloads/bin/fabric-ca-server fabric-ca-server-org1/

# Creating TLS folder and copying needed certificates
cd fabric-ca-server-org1
mkdir tls

# # Copying the rca-admin TLS-certificate and private key
cp ../fabric-ca-client/tls-ca/rca-admin/msp/signcerts/cert.pem tls
cp ../fabric-ca-client/tls-ca/rca-admin/msp/keystore/key.pem tls

# Init the server-org1
./fabric-ca-server init -b rca-admin:rca-Welkom01!


# Setting the config values for ~/fabric-ca-server-tls/fabric-ca-server-config.yaml
# Reading the input from user, leaving blank will insert default value.
read -p "Enter the port [Default: 7055]: " portid
read -p "Enter the CA name [Default: Spark!LivingLab-CA]: " canameid
read -p "Enter the listenAddress [Default: 127.0.0.1:9444]: " listenaddressid

# Setting default values.
portid=${portid:-7055}
canameid=${canameid:-Spark!LivingLab-CA}
listenaddressid=${listenaddressid:-127.0.0.1:9444}

# Setting values in fabric-ca-server-config.yaml
sed -i '43s\.*\port: '$portid'\' fabric-ca-server-config.yaml
sed -i '69s\.*\  enabled: true\' fabric-ca-server-config.yaml
sed -i '71s\.*\  certfile: tls/cert.pem\' fabric-ca-server-config.yaml
sed -i '72s\.*\  keyfile: tls/key.pem\' fabric-ca-server-config.yaml
sed -i '89s\.*\  name: '$canameid'\' fabric-ca-server-config.yaml
sed -i '460s\.*\    listenAddress: '$listenaddressid'\' fabric-ca-server-config.yaml


# To delete the certificates after changes to csr
#rm ca-cert.pem
#sudo rm -rf msp

# Start the Organization CA (Spark!LivingLab-CA)
./fabric-ca-server start