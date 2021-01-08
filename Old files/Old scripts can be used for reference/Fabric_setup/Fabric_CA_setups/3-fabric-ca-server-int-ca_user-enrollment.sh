#!/bin/bash

# Using the Fabric CA client CLI commands to enroll and register the bootstrap user.
# The enrollment process is used to generate the certificate and private key pair which forms the node identity.
# Folders required for enrollment : - fabric-ca-client
#										- tls-ca
#										- tls-root-cert

# The folders that are present in the fabric-ca-client directory are used for the following:
# tls-ca: Store the certificates that are issued when the Fabric CA client enroll command is run against the TLS CA server to enroll the TLS CA bootstrap identity.
# tls-root-cert: Know where the TLS CA root certificate resides that allows the Fabric CA client to communicate with the TLS CA server.

####################################################################################################################################################################

# Enroll the Intermediate CA admin
# Info: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#enroll-the-intermediate-ca-admin
cd ~/fabric-ca-client
./fabric-ca-client enroll -d -u https://ica-admin:'ica-Welkom01!'@localhost:7056 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server, localhost' --mspdir int-ca/ica-admin/msp