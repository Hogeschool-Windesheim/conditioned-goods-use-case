#!/bin/bash

# Create directories and download the client binary files.
mkdir ~/Downloads/
cd ~/Downloads/
wget https://github.com/hyperledger/fabric-ca/releases/download/v1.4.9/hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz
tar -xzf hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz

# Create folder: fabric-ca-client with subfolders: tls-ca, org1-ca and int-ca.
mkdir ~/fabric-ca-client
cp ~/Downloads/bin/fabric-ca-client ~/fabric-ca-client/
cd ~/fabric-ca-client
mkdir Spark-TLS-CA Spark-CA Spark-INT-CA tls-root-cert

# Set the environment variables
echo 'export FABRIC_CA_CLIENT_HOME=~/fabric-ca-client' >> ~/.profile
echo 'export FABRIC_CA_CLIENT_TLS_CERTFILES=~/fabric-ca-client/tls-root-cert' >> ~/.profile
source ~/.profile

# Create the folder were container volumes are mounted.
mkdir ~/container-volumes
cd ~/container-volumes
mkdir Spark-TLS-CA Spark-CA Spark-INT-CA

docker network create CondGoods-Network
# Create the docker container for TLS
#docker-compose up -d





# *** Spark-TLS REGISTER/ENROLLMENTS ***
# Copy the TLS root certificate.
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

# Enroll the tls-admin
cd ~/fabric-ca-client/
./fabric-ca-client enroll -d -u https://tls-admin:'tls-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'fabric-server,localhost' --mspdir Spark-TLS-CA/tls-admin/msp

# *** Register and enroll the organization CA bootstrap identity with the TLS CA ***
# Register the organization CA
./fabric-ca-client register -d --id.name rca-admin --id.secret rca-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir Spark-TLS-CA/tls-admin/msp
# Enroll the rca-admin
./fabric-ca-client enroll -d -u https://rca-admin:'rca-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'fabric-server,localhost' --mspdir Spark-TLS-CA/rca-admin/msp

# *** (Optional) Register and enroll the Intermediate CA admin with the TLS CA ***
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name ica-admin --id.secret ica-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir Spark-TLS-CA/tls-admin/msp
# Enroll the ica-admin
./fabric-ca-client enroll -d -u https://ica-admin:'ica-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'fabric-server, localhost' --mspdir Spark-TLS-CA/ica-admin/msp

################################################

# Setting temporary variable to the key file in tls-admin/msp/keystore
cd ~/fabric-ca-client/Spark-TLS-CA/tls-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/Spark-TLS-CA/tls-admin/msp/keystore/$tempCert ~/fabric-ca-client/Spark-TLS-CA/tls-admin/msp/keystore/key.pem

################################################

# Setting temporary variable to the key file in rca-admin/msp/keystore
cd ~/fabric-ca-client/Spark-TLS-CA/rca-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/Spark-TLS-CA/rca-admin/msp/keystore/$tempCert ~/fabric-ca-client/Spark-TLS-CA/rca-admin/msp/keystore/key.pem

################################################

# Setting temporary variable to the key file in ica-admin/msp/keystore
cd ~/fabric-ca-client/Spark-TLS-CA/ica-admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/Spark-TLS-CA/ica-admin/msp/keystore/$tempCert ~/fabric-ca-client/Spark-TLS-CA/ica-admin/msp/keystore/key.pem

################################################





################################################

# *** Spark-CA Setup ***
# Create folder for tls on Spark-CA container and copy the RCA-ADMIN public and private key, otherwise container won't start.
mkdir ~/container-volumes/Spark-CA/tls

cp ~/fabric-ca-client/Spark-TLS-CA/rca-admin/msp/signcerts/cert.pem ~/container-volumes/Spark-CA/tls
cp ~/fabric-ca-client/Spark-TLS-CA/rca-admin/msp/keystore/key.pem ~/container-volumes/Spark-CA/tls

# setup docker container
#docker-compose up -d

#sed -i '43s\.*\port: 7055\' ~/container-volumes/Spark-CA/fabric-ca-server-config.yaml


# Enroll the rca-admin to Spark-CA
cd ~/fabric-ca-client/
./fabric-ca-client enroll -d -u https://rca-admin:"rca-Welkom01!"@localhost:7055 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost' --mspdir Spark-CA/rca-admin/msp



# *** Spark-INT-CA Setup ***
# Create folder for tls on Spark-CA container and copy the RCA-ADMIN public and private key, otherwise container won't start.
#mkdir ~/container-volumes/Spark-INT-CA/tls

#cp ~/fabric-ca-client/Spark-TLS-CA/ica-admin/msp/signcerts/cert.pem ~/container-volumes/Spark-INT-CA/tls
#cp ~/fabric-ca-client/Spark-TLS-CA/ica-admin/msp/keystore/key.pem ~/container-volumes/Spark-INT-CA/tls

# Copying TLS CA root certificate to intermediate CA
# This certificate can also be copied from fabric-ca-client/tls-root-cert
#cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/container-volumes/Spark-INT-CA/tls/tls-ca-cert.pem

#docker-compose up -d

#export FABRIC_CA_SERVER_SIGNING_PROFILES_CA_CACONSTRAINT_MAXPATHLEN=0
#export FABRIC_CA_SERVER_CSR_CN=
#export FABRIC_CA_SERVER_CSR_CA_PATHLENGTH=0
#export FABRIC_CA_SERVER_INTERMEDIATE_PARENTSERVER_URL=https://rca-admin:'rca-Welkom01!'@localhost:7055
#export FABRIC_CA_SERVER_INTERMEDIATE_PARENTSERVER_CANAME=Spark-CA
#export FABRIC_CA_SERVER_INTERMEDIATE_ENROLLMENT_HOSTS=localhost
#export FABRIC_CA_SERVER_INTERMEDIATE_ENROLLMENT_PROFILE=ca
#export FABRIC_CA_SERVER_INTERMEDIATE_TLS_CERTFILES=tls/tls-ca-cert.pem

#BOVENSTAANDE WERKT WEL, MAAR MAAKT GEEN CA-CHAIN.PEM AAN

# Register the icaadmin to the Spark!LivingLab-CA
#cd ~/fabric-ca-client/
#./fabric-ca-client register -u https://localhost:7055  --id.name ica-admin --id.secret ica-Welkom01! --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir Spark-CA/rca-admin/msp

################################################

# Setting temporary variable to the key file in ica-admin/msp/keystore
#cd ~/fabric-ca-client/Spark-CA/rca-admin/msp/keystore/
#tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
#mv ~/fabric-ca-client/Spark-CA/rca-admin/msp/keystore/$tempCert ~/fabric-ca-client/Spark-CA/rca-admin/msp/keystore/rca-key.pem

################################################

# Setting temporary variable to the key file in ica-admin/msp/keystore
#cd ~/fabric-ca-client/Spark-INT-CA/ica-admin/msp/keystore/
#tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
#mv ~/fabric-ca-client/Spark-INT-CA/ica-admin/msp/keystore/$tempCert ~/fabric-ca-client/Spark-INT-CA/ica-admin/msp/keystore/ica-key.pem

################################################

# *** Creating the folder structures ***
cd ~/
mkdir organizations
cd organizations/
mkdir fabric-ca ordererOrganizations peerOrganizations

mkdir ordererOrganizations/spark
mkdir peerOrganizations/spark

mkdir peerOrganizations/spark/msp
cd ~/organizations/peerOrganizations/spark/msp/
mkdir cacerts intermediatecerts tlscacerts tlsintermediatecerts

cp ~/container-volumes/Spark-CA/ca-cert.pem ~/organizations/peerOrganizations/spark/msp/cacerts/ca-cert.crt
#cp ~/fabric-ca-server-int-ca/ca-cert.pem ~/organizations/peerOrganizations/spark/msp/intermediatecerts/ca-cert.crt
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem  ~/organizations/peerOrganizations/spark/msp/tlscacerts/ca-cert.pem

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
./fabric-ca-client register -d --id.name orderer0-spark --id.secret orderer0-Welkom01! -u https://localhost:7054 --mspdir Spark-TLS-CA/tls-admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://orderer0-spark:'orderer0-Welkom01!'@localhost:7054 --mspdir Spark-TLS-CA/orderer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity orderer0-spark
cd ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/
cp ~/fabric-ca-client/Spark-TLS-CA/orderer0-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity orderer0-spark
cd ~/fabric-ca-client/Spark-TLS-CA/orderer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/tls/tls-ca-cert.pem

# ENROLL TO THE SPARK-CA --> NORMALY IT HAS ITS OWN CA
./fabric-ca-client register -d --id.name orderer0-spark --id.secret orderer0-Welkom01! -u https://localhost:7055 --mspdir Spark-CA/rca-admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://orderer0-spark:'orderer0-Welkom01!'@localhost:7055 --mspdir ~/organizations/ordererOrganizations/spark/orderers/orderer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem









#================================================================================================================================================================================================================================================================================

# Creating folders for identity peer0-spark
cd ~/organizations/
mkdir peerOrganizations/spark/peers
mkdir peerOrganizations/spark/peers/peer0-spark
mkdir peerOrganizations/spark/peers/peer0-spark/msp peerOrganizations/spark/peers/peer0-spark/tls

# *** TLS CONFIG FOR peer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer0-spark --id.secret peer0-spark-Welkom01! -u https://localhost:7054 --mspdir Spark-TLS-CA/tls-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer0-spark:'peer0-spark-Welkom01!'@localhost:7054 --mspdir Spark-TLS-CA/peer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity peer0-spark
cd ~/organizations/peerOrganizations/spark/peers/peer0-spark/
cp ~/fabric-ca-client/Spark-TLS-CA/peer0-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity peer0-spark
cd ~/fabric-ca-client/Spark-TLS-CA/peer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/organizations/peerOrganizations/spark/peers/peer0-spark/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR peer0-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer0-spark --id.secret peer0-spark-Welkom01! -u https://localhost:7055 --mspdir Spark-CA/rca-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer0-spark:'peer0-spark-Welkom01!'@localhost:7055 --mspdir ~/organizations/peerOrganizations/spark/peers/peer0-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/spark/peers/peer0-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert peer0-spark-key.pem

cd ~/organizations/peerOrganizations/spark/peers/peer1-spark/msp
cat << EOT >> config.yaml
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7055.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7055.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7055.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7055.pem
    OrganizationalUnitIdentifier: orderer
EOT
#================================================================================================================================================================================================================================================================================

# Creating folders for identity peer1-spark
cd ~/organizations/
mkdir peerOrganizations/spark/peers/peer1-spark
mkdir peerOrganizations/spark/peers/peer1-spark/msp peerOrganizations/spark/peers/peer1-spark/tls

# *** TLS CONFIG FOR peer1-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer1-spark --id.secret peer1-spark-Welkom01! -u https://localhost:7054 --mspdir Spark-TLS-CA/tls-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer1-spark:'peer1-spark-Welkom01!'@localhost:7054 --mspdir Spark-TLS-CA/peer1-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity peer1-spark
cd ~/organizations/peerOrganizations/spark/peers/peer1-spark/
cp ~/fabric-ca-client/Spark-TLS-CA/peer1-spark/msp/signcerts/cert.pem tls/

# Copy the private key of the identity peer1-spark
cd ~/fabric-ca-client/Spark-TLS-CA/peer1-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/spark/peers/peer1-spark/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/organizations/peerOrganizations/spark/peers/peer1-spark/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR peer1-spark IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name peer1-spark --id.secret peer1-spark-Welkom01! -u https://localhost:7055 --mspdir Spark-CA/rca-admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://peer1-spark:'peer1-spark-Welkom01!'@localhost:7055 --mspdir ~/organizations/peerOrganizations/spark/peers/peer1-spark/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/spark/peers/peer1-spark/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert peer1-spark-key.pem

#================================================================================================================================================================================================================================================================================

# *** PEER SETUP ***
# USE DOCKER-COMPOSE.YAML FILES

#================================================================================================================================================================================================================================================================================

# Create admin-client certs on orderer CA (we use Spark-CA for now)
mkdir ~/admin-client

./fabric-ca-client register -d --id.name admin-client --id.secret admin-client-Welkom01! -u https://localhost:7054 --mspdir Spark-TLS-CA/tls-admin/msp --id.type admin --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'fabric-server,localhost'
./fabric-ca-client enroll -u https://admin-client:'admin-client-Welkom01!'@localhost:7054 --mspdir Spark-TLS-CA/admin-client/msp --csr.hosts 'fabric-server,localhost' --tls.certfiles tls-root-cert/tls-ca-cert.pem

cd ~/fabric-ca-client/Spark-TLS-CA/admin-client/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the TLS-key file to key.pem
mv $tempCert admin-client-tls-key.pem

cp ~/fabric-ca-client/Spark-TLS-CA/admin-client/msp/keystore/admin-client-tls-key.pem ~/admin-client/
cp ~/fabric-ca-client/Spark-TLS-CA/admin-client/msp/signcerts/cert.pem ~/admin-client/
mv ~/admin-client/cert.pem ~/admin-client/admin-client-tls-cert.pem
cp ~/container-volumes/Spark-TLS-CA/ca-cert.pem ~/admin-client/tls-ca-cert.pem
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

export OSN_TLS_CA_ROOT_CERT=~/organizations/peerOrganizations/spark/peers/orderer0-spark/tls/tls-ca-cert.pem
export ADMIN_TLS_SIGN_CERT=~/admin-client/admin-client-tls-cert.pem
export ADMIN_TLS_PRIVATE_KEY=~/admin-client/admin-client-tls-key.pem

./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9440 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY

# Command below dependend on the exports for the variables
./osnadmin channel list -c spark-vebabox-channel -o localhost:9440 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY

export ORDERER_CAFILE=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
export TLS_CERTFILE=/etc/hyperledger/fabric/tls/cert.pem
export ADMIN_TLS_PRIVATE_KEY=/etc/hyperledger/fabric/tls/key.pem

./peer channel join -b /var/hyperledger/production/genesis_block.pb -o fabric-server:9440 --cafile /etc/hyperledger/fabric/tls/tls-ca-cert.pem --certfile /etc/hyperledger/fabric/tls/cert.pem --keyfile /etc/hyperledger/fabric/tls/key.pem