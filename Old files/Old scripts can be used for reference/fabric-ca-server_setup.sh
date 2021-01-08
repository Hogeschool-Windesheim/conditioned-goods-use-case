#!/bin/bash

# The following script will setup and install the Fabric-TLS-CA server.

#	Download files and unpack them in ~/Downloads
wget https://github.com/hyperledger/fabric-ca.git
tar -xzf hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz

cd

#	Create the directory and copy the fabric-ca-server file
mkdir fabric-ca-server-tls
cp Downloads/bin/fabric-ca-server fabric-ca-server-tls/
cd fabric-ca-server-tls

# Edit the 'fabric-ca-server-config.yaml' file
# change tls to true
# change CA name: Spark!LivingLab-CA
# remove ca profiles except tls
# IDEA for later (so don't do this): change csr cn: Spark!LivingLab-TLS-CA

# To delete the certificates after changes to csr
# rm ca-cert.pem
# sudo rm -rf msp

./fabric-ca-server start
# When you need to modify the CA admin password, use the Fabric CA client identity command.


cd
cp fabric-ca-server-tls/ca-cert.pem fabric-ca-client/tls-root-cert/tls-ca-cert.pem
# IMPORTANT: This TLS CA root certificate will need to be available on each client system that will run commands against the TLS CA.