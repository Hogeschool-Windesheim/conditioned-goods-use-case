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

# Enroll the rca-admin to Spark!LivingLab-CA
cd ~/fabric-ca-client/
./fabric-ca-client enroll -d -u https://rca-admin:"rca-Welkom01!"@localhost:7055 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'Ubuntu-20,localhost' --mspdir org1-ca/rca-admin/msp



# Setting temporary variable to the key file in rca-admin/msp/keystore
cd ~/fabric-ca-client/org1-ca/rca-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to org1-key.pem
mv ~/fabric-ca-client/org1-ca/rca-admin/msp/keystore/$tempCert ~/fabric-ca-client/org1-ca/rca-admin/msp/keystore/org1-key.pem



# Register the icaadmin to the Spark!LivingLab-CA
cd ~/fabric-ca-client/
./fabric-ca-client register -u https://localhost:7055  --id.name icaadmin --id.secret ica-Welkom01! --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir org1-ca/rca-admin/msp