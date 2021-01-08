#!/bin/bash

# TLS-CA name: Spark!LivingLab-TLS-CA
# Default port: 7054

#  credentials:
#	username: tls-admin
#	password: tls-Welkom01!

# *** LDAP USERS ***
# If you are using LDAP server for your user registry, then the register step is not required because the identities already exist in the LDAP database


# ***DEPLOYING THE TLS CA AND CREATE CLIENT CA ***
# A 'Downloads' folder needs to be present.
cd ~/Downloads/
wget https://github.com/hyperledger/fabric-ca/releases/download/v1.4.9/hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz
tar -xzf hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz


# Create folder: fabric-ca-client with subfolders: tls-ca, org1-ca and int-ca.
cd
mkdir fabric-ca-client
cp Downloads/bin/fabric-ca-client fabric-ca-client/
cd fabric-ca-client
mkdir tls-ca org1-ca int-ca tls-root-cert



# Setting PATH variables in ~/.profile
echo 'export FABRIC_CA_CLIENT_HOME=~/fabric-ca-client' >> ~/.profile
echo 'export FABRIC_CA_CLIENT_TLS_CERTFILES=~/fabric-ca-client/tls-root-cert' >> ~/.profile
source ~/.profile


# Create folder: fabric-ca-server-tls
cd
mkdir fabric-ca-server-tls
cp Downloads/bin/fabric-ca-server fabric-ca-server-tls/

# Init the TLS-CA server
cd fabric-ca-server-tls
./fabric-ca-server init -b tls-admin:tls-Welkom01!


# Setting the config values for ~/fabric-ca-server-tls/fabric-ca-server-config.yaml
# Reading the input from user, leaving blank will insert default value.
read -p "Enter the port [Default: 7054]: " portid
read -p "Enter the CA name [Default: Spark!LivingLab-TLS-CA]: " canameid
read -p "Enter the listenAddress [Default: 127.0.0.1:9444]: " listenaddressid

# Setting default values.
portid=${portid:-7054}
canameid=${canameid:-Spark!LivingLab-TLS-CA}
listenaddressid=${listenaddressid:-127.0.0.1:9444}

# Setting values in fabric-ca-server-config.yaml
sed -i '43s\.*\port: '$portid'\' fabric-ca-server-config.yaml
sed -i '69s\.*\  enabled: true\' fabric-ca-server-config.yaml
sed -i '89s\.*\  name: '$canameid'\' fabric-ca-server-config.yaml
sed -i '274,281d' fabric-ca-server-config.yaml
sed -i '451s\.*\    listenAddress: '$listenaddressid'\' fabric-ca-server-config.yaml

# To delete the certificates after changes to csr
#rm ca-cert.pem
#sudo rm -rf msp

# Start the TLS-CA server
./fabric-ca-server start
