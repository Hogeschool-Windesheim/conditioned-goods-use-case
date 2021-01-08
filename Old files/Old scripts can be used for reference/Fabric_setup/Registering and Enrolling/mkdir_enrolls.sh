#!/bin/bash

cd ~/
mkdir organizations
cd organizations/
mkdir fabric-ca ordererOrganizations peerOrganizations

mkdir ordererOrganizations/spark
mkdir peerOrganizations/spark

mkdir ordererOrganizations/vebabox
mkdir peerOrganizations/vebabox

#mkdir ordererOrganizations/vebabox/msp ordererOrganizations/vebabox/orderers
#mkdir ordererOrganizations/vebabox/orderers/orderer0-vebabox
#mkdir ordererOrganizations/vebabox/orderers/orderer0-vebabox/msp ordererOrganizations/vebabox/orderers/orderer0-vebabox/tls


#mkdir peerOrganizations/vebabox/msp peerOrganizations/vebabox/peers
#mkdir peerOrganizations/vebabox/peers/peer0-vebabox
#mkdir peerOrganizations/vebabox/peers/peer0-vebabox/msp peerOrganizations/vebabox/peers/peer0-vebabox/tls

mkdir peerOrganizations/spark/msp
cd ~/organizations/peerOrganizations/spark/msp/
mkdir cacerts intermediatecerts tlscacerts tlsintermediatecerts


# Copying root certs from TLS-CA, ORG-CA, INT-ORG-CA (INT-CA) --> if not working change .crt extentions to .pem
cp ~/fabric-ca-server-org1/ca-cert.pem ~/organizations/peerOrganizations/spark/msp/cacerts/ca-cert.crt
cp ~/fabric-ca-server-int-ca/ca-cert.pem ~/organizations/peerOrganizations/spark/msp/intermediatecerts/ca-cert.crt
cp ~/fabric-ca-server-tls/ca-cert.pem  ~/organizations/peerOrganizations/spark/msp/tlscacerts/ca-cert.pem
#When using an intermediate TLS-CA add the root cert to the tlsintermediate folder, for example:
#cp ~/fabric-ca-server-int-tls/ca-cert.pem  ~/organizations/peerOrganizations/spark/msp/tlsintermediatecerts/ca-cert.crt


cat << EOT >> config.yaml
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-cert.crt
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-cert.crt
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-cert.crt
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-cert.crt
    OrganizationalUnitIdentifier: orderer
EOT


#================================================================================================================================================================================================================================================================================

# Creating folders for identity orderer0-spark
cd ~/organizations/
mkdir ordererOrganizations/spark/msp ordererOrganizations/spark/orderers
mkdir ordererOrganizations/spark/orderers/orderer0-spark
mkdir ordererOrganizations/spark/orderers/orderer0-spark/msp ordererOrganizations/spark/orderers/orderer0-spark/tls

# *** TLS CONFIG FOR orderer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name orderer0-spark --id.secret orderer0-Welkom01! -u https://localhost:7054 --mspdir tls-ca/tlsadmin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://orderer0-spark:'orderer0-spark-Welkom01!'@localhost:7054 --mspdir tls-ca/orderer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity orderer0-spark
cd ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/
cp ~/fabric-ca-client/tls-ca/orderer0-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity orderer0-spark
cd ~/fabric-ca-client/tls-ca/orderer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/fabric-ca-server-tls/ca-cert.pem ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR orderer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name orderer0-spark --id.secret orderer0-spark-Welkom01! -u https://localhost:7056 --mspdir int-ca/ica-admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://orderer0-spark:'orderer0-spark-Welkom01!'@localhost:7056 --mspdir ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert orderer0-spark-key.pem

#================================================================================================================================================================================================================================================================================

# Creating folders for identity peer0-spark
cd ~/organizations/
mkdir peerOrganizations/spark/peers
mkdir peerOrganizations/spark/peers/peer0-spark
mkdir peerOrganizations/spark/peers/peer0-spark/msp peerOrganizations/spark/peers/peer0-spark/tls

# *** TLS CONFIG FOR peer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer0-spark --id.secret peer0-spark-Welkom01! -u https://localhost:7054 --mspdir tls-ca/tlsadmin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer0-spark:'peer0-spark-Welkom01!'@localhost:7054 --mspdir tls-ca/peer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity peer0-spark
cd ~/organizations/peerOrganizations/spark/peers/peer0-spark/
cp ~/fabric-ca-client/tls-ca/peer0-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity peer0-spark
cd ~/fabric-ca-client/tls-ca/peer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/fabric-ca-server-tls/ca-cert.pem ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR peer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer0-spark --id.secret peer0-spark-Welkom01! -u https://localhost:7056 --mspdir int-ca/ica-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer0-spark:'peer0-spark-Welkom01!'@localhost:7056 --mspdir ~/organizations/peerOrganizations/spark/peers/peer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/spark/peers/peer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert peer0-spark-key.pem

#================================================================================================================================================================================================================================================================================

# Creating folders for identity peer1-spark
cd ~/organizations/
mkdir peerOrganizations/spark/peers/peer1-spark
mkdir peerOrganizations/spark/peers/peer1-spark/msp peerOrganizations/spark/peers/peer1-spark/tls

# *** TLS CONFIG FOR peer1-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer1-spark --id.secret peer1-spark-Welkom01! -u https://localhost:7054 --mspdir tls-ca/tlsadmin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer1-spark:'peer1-spark-Welkom01!'@localhost:7054 --mspdir tls-ca/peer1-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity peer1-spark
cd ~/organizations/peerOrganizations/spark/peers/peer1-spark/
cp ~/fabric-ca-client/tls-ca/peer1-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity peer1-spark
cd ~/fabric-ca-client/tls-ca/peer1-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/spark/peers/peer1-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/fabric-ca-server-tls/ca-cert.pem ~/organizations/peerOrganizations/spark/peers/peer1-spark/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR peer1-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer1-spark --id.secret peer1-spark-Welkom01! -u https://localhost:7056 --mspdir int-ca/ica-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer1-spark:'peer1-spark-Welkom01!'@localhost:7056 --mspdir ~/organizations/peerOrganizations/spark/peers/peer1-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/spark/peers/peer1-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert peer1-spark-key.pem

#================================================================================================================================================================================================================================================================================

















./fabric-ca-client register -d --id.name spark-admin --id.secret spark-Welkom01! -u https://localhost:7054 --mspdir ./tls-ca/tlsadmin/msp --tls.certfiles tls-root-cert/tls-ca-cert.pem
./fabric-ca-client enroll -u https://spark-admin:'spark-Welkom01!'@localhost:7054 --mspdir ./tls-ca/spark-admin/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

./fabric-ca-client register -d --id.name vebabox-admin --id.secret vebabox-Welkom01! -u https://localhost:7054 --mspdir ./tls-ca/tlsadmin/msp --tls.certfiles tls-root-cert/tls-ca-cert.pem
./fabric-ca-client enroll -u https://vebabox-admin:'vebabox-Welkom01!'@localhost:7054 --mspdir ./vebabox-ca/vebabox-admin/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

./fabric-ca-client enroll -u https://spark-admin:'spark-Welkom01!'@localhost:7056 --mspdir ./org1-ca/spark-admin/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Enroll new identities
# username and password used at init do not need to be registerd at the server the init was run. 
# mspdir in register command is not where new certificates are stored, but the mspdir is used to run the command with that user for example: tls-admin.
#
# step 1: Register and enroll the identity at TLS-CA
# 	register at tls-ca --> ./fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadminpw -u https://my-machine.example.com:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
#	in the command above the following msp directory is used to point to the certifactes of the tls-admin
#
#
# 	enroll at tls-ca --> ./fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@my-machine.example.com:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'host1,*.example.com' --mspdir tls-ca/rcaadmin/msp
#	in the command above the following msp directory is used to point to the location where the newly generated certificates are stored. 
#
#
# step 2:
#	register at root CA, unless an int-ca is being used. --> Then register at int-ca of the organization
#	enroll at root CA, unless an int-ca is being used. --> Then enroll at int-ca of the organization
#
#


# Setting temporary variable to the key file in rca-admin/msp/keystore
cd ~/fabric-ca-client/org1-ca/spark-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to org1-key.pem
mv ~/fabric-ca-client/org1-ca/spark-admin/msp/keystore/$tempCert ~/fabric-ca-client/org1-ca/spark-admin/msp/keystore/spark-admin-key.pem
mv ~/fabric-ca-client/org1-ca/spark-admin/msp/signcerts/cert.pem ~/fabric-ca-client/org1-ca/spark-admin/msp/signcerts/spark-admin-cert.pem
