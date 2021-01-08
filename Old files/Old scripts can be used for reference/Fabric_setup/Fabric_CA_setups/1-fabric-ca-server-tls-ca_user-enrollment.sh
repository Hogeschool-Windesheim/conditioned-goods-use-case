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

# Copying the TLS CA public key to the fabric-ca-client/tls-root-cert directory.
cd
cp fabric-ca-server-tls/ca-cert.pem fabric-ca-client/tls-root-cert/tls-ca-cert.pem



# *** Enroll the bootstrap user with the TLS-CA ***
cd fabric-ca-client/
./fabric-ca-client enroll -d -u https://tls-admin:'tls-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20, localhost' --mspdir tls-ca/tlsadmin/msp



# *** Register and enroll the organization CA bootstrap identity with the TLS CA ***
# Register the organization CA
./fabric-ca-client register -d --id.name rca-admin --id.secret rca-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
# Enroll the rca-admin
./fabric-ca-client enroll -d -u https://rca-admin:'rca-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20,localhost' --mspdir tls-ca/rca-admin/msp



# Setting temporary variable to the key file in rca-admin/msp/keystore
cd ~/fabric-ca-client/tls-ca/rca-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/tls-ca/rca-admin/msp/keystore/$tempCert ~/fabric-ca-client/tls-ca/rca-admin/msp/keystore/key.pem



# *** (Optional) Register and enroll the Intermediate CA admin with the TLS CA ***
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name ica-admin --id.secret ica-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
# Enroll the ica-admin
./fabric-ca-client enroll -d -u https://ica-admin:'ica-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20, localhost' --mspdir tls-ca/ica-admin/msp