# Extra info:

# Dependencies:
# - docker-compose.yaml

#!/bin/bash

# *** Variables for script:
# General
	company=spark
	ca_client_home="$HOME"/fabric-ca-client
	ca_client_tls_certfiles="$HOME"/fabric-ca-client/tls-root-cert
  hostname=Spark-Node

# Docker
	docker_network=CondGoods-Network

# Docker TLS-CA container
	tls_admin=tls-admin
	tls_admin_pass=tls-admin-Welkom01!

	docker_tls_service_name=$company"-tls-ca"
	docker_tls_container_name=$company"-TLS-CA"
	docker_tls_ca_name=$company"-TLS-CA"
	docker_tls_port=7054

# Docker Organizational-CA container
	ca_admin=rca-admin
	ca_admin_pass=rca-admin-Welkom01!

	docker_ca_service_name=$company"-ca"
	docker_ca_container_name=$company"-CA"
	docker_ca_name=$company"-CA"
	docker_ca_port=7055

# Docker Intermediate-CA container
	intca_admin=int-admin
	intca_admin_pass=int-admin-Welkom01!

	docker_intca_service_name=$company"-int-ca"
	docker_intca_container_name=$company"-int-ca"
	docker_intca_name=$company"-INT-CA"
	docker_intca_port=7056

# Docker Peer containers
  docker_peer0="peer0-"$company
  docker_peer0_pass=peer0-spark-Welkom01!
  docker_peer0_service_name=$docker_peer0
  docker_peer0_container_name=$docker_peer0
  docker_peer0_couchdb_username=peer0-couchdb-admin
  docker_peer0_couchdb_pass=peer0-couchdb-Welkom01!

  docker_peer1="peer1-"$company
  docker_peer1_pass=peer1-spark-Welkom01!
  docker_peer1_service_name=$docker_peer1
  docker_peer1_container_name=$docker_peer1
  docker_peer1_couchdb_username=peer1-couchdb-admin
  docker_peer1_couchdb_pass=peer1-couchdb-Welkom01!

# Docker orderer container
  docker_orderer0="orderer0-"$company
  docker_orderer0_pass=orderer0-spark-Welkom01!
  docker_orderer0_service_name=$docker_orderer0
  docker_orderer0_container_name=$docker_orderer0

  docker_orderer1="orderer1-"$company
  docker_orderer1_pass=orderer1-spark-Welkom01!
  docker_orderer1_service_name=$docker_orderer1
  docker_orderer1_container_name=$docker_orderer1

  docker_orderer2="orderer2-"$company
  docker_orderer2_pass=orderer2-spark-Welkom01!
  docker_orderer2_service_name=$docker_orderer2
  docker_orderer2_container_name=$docker_orderer2


# admin users
  peer_admin=peer-admin
  peer_admin_pass=peer-admin-Welkom01!


echo
echo "Generating folderstructure.."
echo

# Create the folder structure that fabric will use for certificates a.o.
cd
mkdir -p ~/{Downloads,scripts/{tls-ca-compose,ca-compose,peers-compose,orderer-compose}}


mkdir -p organizations/{fabric-ca,peerOrganizations}
mkdir organizations/peerOrganizations/$company

mkdir -p organizations/peerOrganizations/$company/{msp,peers}
mkdir -p organizations/peerOrganizations/$company/msp/{cacerts,intermediatecerts,tlscacerts,tlsintermediatecerts}
mkdir -p organizations/peerOrganizations/$company/peers/{$docker_peer0,$docker_peer1,$docker_orderer0,$docker_orderer1,$docker_orderer2}
mkdir -p organizations/peerOrganizations/$company/peers/$docker_peer0/{msp,tls}
mkdir -p organizations/peerOrganizations/$company/peers/$docker_peer1/{msp,tls}
mkdir -p organizations/peerOrganizations/$company/peers/$docker_orderer0/{msp,tls}
mkdir -p organizations/peerOrganizations/$company/peers/$docker_orderer1/{msp,tls}
mkdir -p organizations/peerOrganizations/$company/peers/$docker_orderer2/{msp,tls}







# Create the folder were container volumes are mounted.
mkdir -p container-volumes/{$docker_tls_ca_name,$docker_ca_name/tls,$docker_intca_name/tls}
# Create the CondGoods-Network
echo "Generating docker network: " $docker_network
docker network create $docker_network

# Creating the fabric-client directory and downloading needed files
echo 
echo "Creating the fabric-client directory and downloading needed files.."
echo 

cd Downloads/
wget https://github.com/hyperledger/fabric-ca/releases/download/v1.4.9/hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz
tar -xzf hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz

# Create folder: fabric-ca-client with subfolders: tls-ca, org1-ca and int-ca.
cd
mkdir -p fabric-ca-client/{$docker_tls_ca_name,$docker_ca_name,$docker_intca_name,tls-root-cert}
cp Downloads/bin/fabric-ca-client $ca_client_home/fabric-ca-client
rm -r Downloads/*

# compose file for ca deployment needs to exist in scripts/ca-compose, if not there copy it in
# make sure 
echo
echo "Creating docker-container: " $docker_tls_container_name
echo

cd scripts/tls-ca-compose
cat << EOT >> docker-compose.yaml
# Docker-compose file for the TLS-CA and Organization-CA (fe: $docker_tls_ca_name, $docker_ca_name)

version: '3.8'

networks:
  default:
    name: $docker_network

services:

  $docker_tls_service_name:
    image: hyperledger/fabric-ca:latest
    container_name: $docker_tls_container_name
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/$docker_tls_ca_name
      - FABRIC_CA_SERVER_PORT=$docker_tls_port
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_CA_NAME=$docker_tls_ca_name
      # Line 274 till 281 needs to be removed (remove profile) in fabric-ca-server-config.yaml
      #- FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9444
    ports:
      - "$docker_tls_port:$docker_tls_port"
    volumes:
      - "~/container-volumes/$docker_tls_ca_name:/etc/hyperledger/$docker_tls_ca_name"
    command: sh -c "fabric-ca-server start -b $tls_admin:$tls_admin_pass"
EOT

docker-compose up -d
sleep 2

################################################

# Set the environment variables
cd
echo 'export FABRIC_CA_CLIENT_HOME='$ca_client_home >> ~/.profile
echo 'export FABRIC_CA_CLIENT_TLS_CERTFILES='$ca_client_tls_certfiles >> ~/.profile
source ~/.profile

################################################

# *** TLS REGISTER/ENROLLMENTS ***
# Copy the TLS root certificate.
#cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

cd fabric-ca-client/

# Enroll the $tls_admin
echo
echo "Enroll the " $tls_admin " -> " $docker_tls_ca_name
./fabric-ca-client enroll -d -u https://$tls_admin:$tls_admin_pass@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts "$hostname,localhost" --mspdir $docker_tls_ca_name/$tls_admin/msp

# *** Register and enroll the organization CA bootstrap identity with the TLS CA ***
# Register the organization CA
echo
echo "Enroll & register the " $ca_admin " -> " $docker_tls_ca_name

./fabric-ca-client register -d --id.name $ca_admin --id.secret $ca_admin_pass -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir $docker_tls_ca_name/$tls_admin/msp
# Enroll the $ca_admin
./fabric-ca-client enroll -d -u https://$ca_admin:$ca_admin_pass@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts "$hostname,localhost" --mspdir $docker_tls_ca_name/$ca_admin/msp

# *** (Optional) Register and enroll the Intermediate CA admin with the TLS CA ***
# echo
# echo "Enroll & register the " $ica_admin " -> " $docker_tls_ca_name
#./fabric-ca-client register -d --id.name $ica_admin --id.secret $ica_admin_pass -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir $docker_tls_ca_name/$tls_admin/msp
# Enroll the ica-admin
#./fabric-ca-client enroll -d -u https://$ica_admin:"$ica_admin_pass"@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts "$hostname, localhost" --mspdir $docker_tls_ca_name/$ica_admin/msp

################################################

# Setting temporary variable to the key file in $tls_admin/msp/keystore
cd ~/fabric-ca-client/$docker_tls_ca_name/$tls_admin/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/$docker_tls_ca_name/$tls_admin/msp/keystore/$tempCert ~/fabric-ca-client/$docker_tls_ca_name/$tls_admin/msp/keystore/key.pem



# Setting temporary variable to the key file in $ca_admin/msp/keystore
cd ~/fabric-ca-client/$docker_tls_ca_name/$ca_admin/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/$docker_tls_ca_name/$ca_admin/msp/keystore/$tempCert ~/fabric-ca-client/$docker_tls_ca_name/$ca_admin/msp/keystore/key.pem



# *** (Optional) ONLY ENABLE WHEN INTERMEDIATE CA ADMIN IS USED 
# Setting temporary variable to the key file in ica-admin/msp/keystore
#cd ~/fabric-ca-client/$docker_tls_ca_name/$ica_admin/msp/keystore/
#tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
#mv ~/fabric-ca-client/$docker_tls_ca_name/$ica_admin/msp/keystore/$tempCert ~/fabric-ca-client/$docker_tls_ca_name/$ica_admin/msp/keystore/key.pem


################################################

# !!! IMPORTANT !!!
# Copy the $ca_admin public and private key, otherwise container won't start.
cp ~/fabric-ca-client/$docker_tls_ca_name/$ca_admin/msp/signcerts/cert.pem ~/container-volumes/$docker_ca_name/tls
cp ~/fabric-ca-client/$docker_tls_ca_name/$ca_admin/msp/keystore/key.pem ~/container-volumes/$docker_ca_name/tls

# Copy the ICA-ADMIN public and private key, otherwise container won't start.
#cp ~/fabric-ca-client/$docker_tls_ca_name/$ica_admin/msp/signcerts/cert.pem ~/container-volumes/$docker_intca_name/tls
#cp ~/fabric-ca-client/$docker_tls_ca_name/$ica_admin/msp/keystore/key.pem ~/container-volumes/$docker_intca_name/tls

# Copying TLS CA root certificate to intermediate CA
# This certificate can also be copied from fabric-ca-client/tls-root-cert
#cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/container-volumes/$docker_intca_name/tls/tls-ca-cert.pem

################################################

echo
echo "Creating docker-container: " $docker_tls_container_name "  optional: " $docker_intca_container_name
echo

cd ~/scripts/ca-compose
cat << EOT >> docker-compose.yaml
# Docker-compose file for the TLS-CA and Organization-CA (fe: $docker_tls_ca_name, $docker_ca_name)

version: '3.8'

networks:
  default:
    name: $docker_network

services:

  $docker_ca_service_name:
    image: hyperledger/fabric-ca:latest
    container_name: $docker_ca_container_name
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/$docker_ca_name
      - FABRIC_CA_SERVER_PORT=$docker_ca_port
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=tls/cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=tls/key.pem
      - FABRIC_CA_SERVER_CA_NAME=$docker_ca_name
      #- FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9444
    ports:
      - "$docker_ca_port:$docker_ca_port"
    volumes:
      - "~/container-volumes/$docker_ca_name:/etc/hyperledger/$docker_ca_name"
    command: sh -c "fabric-ca-server start -b $ca_admin:$ca_admin_pass"



#  $docker_intca_service_name:
#    image: hyperledger/fabric-ca:latest
#    container_name: $docker_intca_container_name
#    environment:
#      - FABRIC_CA_HOME=/etc/hyperledger/$docker_intca_name
#      - FABRIC_CA_SERVER_PORT=$docker_intca_port
#      - FABRIC_CA_SERVER_TLS_ENABLED=true
#      - FABRIC_CA_SERVER_TLS_CERTFILE=tls/cert.pem
#      - FABRIC_CA_SERVER_TLS_KEYFILE=tls/key.pem
#      - FABRIC_CA_SERVER_CA_NAME=$docker_intca_name
#      - FABRIC_CA_SERVER_SIGNING_PROFILES_CA_CACONSTRAINT_MAXPATHLEN=0
#      - FABRIC_CA_SERVER_CSR_CN=
#      - FABRIC_CA_SERVER_CSR_CA_PATHLENGTH=0
#      - FABRIC_CA_SERVER_INTERMEDIATE_PARENTSERVER_URL=https://$ca_admin:$ca_admin_pass@localhost:$docker_ca_port
#      - FABRIC_CA_SERVER_INTERMEDIATE_PARENTSERVER_CANAME=$docker_ca_name
#      - FABRIC_CA_SERVER_INTERMEDIATE_ENROLLMENT_HOSTS=localhost
#      - FABRIC_CA_SERVER_INTERMEDIATE_ENROLLMENT_PROFILE=ca
#      - FABRIC_CA_SERVER_INTERMEDIATE_TLS_CERTFILES=tls/tls-ca-cert.pem
#      #- FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9445
#    ports:
#      - "$docker_intca_port:$docker_intca_port"
#    volumes:
#      - "~/container-volumes/$docker_intca_name:/etc/hyperledger/$docker_intca_name"
#    command: /bin/bash -c "/etc/hyperledger/$docker_intca_name/start-int-ca.sh"
EOT

docker-compose up -d
cd
sleep 4

################################################

# *** Creating organizational MSP
# Copying the ca-certs from containers to organizational msp
cp ~/container-volumes/$docker_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/msp/cacerts/ca-cert.crt
#cp ~container-volumes/$docker_intca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/msp/intermediatecerts/ca-cert.crt
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem  ~/organizations/peerOrganizations/$company/msp/tlscacerts/ca-cert.pem


cat << EOT >> ~/organizations/peerOrganizations/$company/msp/config.yaml
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

################################################

# Enroll the $ca_admin to $docker_ca_name
echo
echo "Enroll the " $ca_admin " -> " $docker_ca_name

cd ~/fabric-ca-client/
./fabric-ca-client enroll -d -u https://$ca_admin:"$ca_admin_pass"@localhost:7055 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost" --mspdir $docker_ca_name/$ca_admin/msp

# Register the intca-admin to the Organizational CA
#cd ~/fabric-ca-client/
#./fabric-ca-client register -u https://localhost:7055  --id.name $intca_admin --id.secret $intca_admin_pass --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir $docker_ca_name/$ca_admin/msp

################################################

# Setting temporary variable to the key file in intca-admin/msp/keystore
#cd ~/fabric-ca-client/$docker_ca_name/$ca_admin/msp/keystore/
#tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
#mv ~/fabric-ca-client/$docker_ca_name/$ca_admin/msp/keystore/$tempCert ~/fabric-ca-client/$docker_ca_name/$ca_admin/msp/keystore/rca-key.pem

################################################

# Setting temporary variable to the key file in intca-admin/msp/keystore
#cd ~/fabric-ca-client/$docker_intca_name/$intca_admin/msp/keystore/
#tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
#mv ~/fabric-ca-client/$docker_intca_name/$intca_admin/msp/keystore/$tempCert ~/fabric-ca-client/$docker_intca_name/$intca_admin/msp/keystore/intca-key.pem

################################################

# *** TLS CONFIG FOR $docker_peer0 IDENTITY ***
# Register and enroll the identity at the TLS-CA.
echo
echo "Register & Enroll the " $docker_peer0 " -> " $docker_tls_ca_name
echo

cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name $docker_peer0 --id.secret $docker_peer0_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost" #$hostname
./fabric-ca-client enroll -d -u https://$docker_peer0:"$docker_peer0_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$docker_peer0/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

echo
echo "Copying cert files"
echo
# Copy the public key of the identity $docker_peer0
cd ~/organizations/peerOrganizations/$company/peers/$docker_peer0/
cp ~/fabric-ca-client/$docker_tls_ca_name/$docker_peer0/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $docker_peer0
cd ~/fabric-ca-client/$docker_tls_ca_name/$docker_peer0/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer0/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer0/tls/tls-ca-cert.pem

################################################

# *** ORGANIZATION CA CONFIG FOR $docker_peer0 IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/
echo
echo "Register & Enroll the " $docker_peer0 " -> " $docker_ca_name
echo

./fabric-ca-client register -d --id.name $docker_peer0 --id.secret $docker_peer0_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_peer0:"$docker_peer0_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert $docker_peer0-key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/config.yaml
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

################################################

# *** TLS CONFIG FOR $docker_peer1 IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/

echo
echo "Register & Enroll the " $docker_peer1 " -> " $docker_tls_ca_name
echo

./fabric-ca-client register -d --id.name $docker_peer1 --id.secret $docker_peer1_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -d -u https://$docker_peer1:"$docker_peer1_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$docker_peer1/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity $docker_peer1
cd ~/organizations/peerOrganizations/$company/peers/$docker_peer1/
cp ~/fabric-ca-client/$docker_tls_ca_name/$docker_peer1/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $docker_peer1
cd ~/fabric-ca-client/$docker_tls_ca_name/$docker_peer1/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer1/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer1/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR $docker_peer1 IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/

echo
echo "Register & Enroll the " $docker_peer1 " -> " $docker_ca_name
echo

./fabric-ca-client register -d --id.name $docker_peer1 --id.secret $docker_peer1_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type peer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_peer1:"$docker_peer1_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_peer1/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_peer1/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert $docker_peer1-key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_peer1/msp/config.yaml
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

# *** TLS CONFIG FOR $peer_admin IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/

echo
echo "Register & Enroll the " $peer_admin " -> " $docker_tls_ca_name
echo

./fabric-ca-client register -d --id.name $peer_admin --id.secret $peer_admin_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type admin --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -d -u https://$peer_admin:"$peer_admin_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$peer_admin/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity $peer_admin
mkdir -p ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/{msp,tls}

cd ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin
cp ~/fabric-ca-client/$docker_tls_ca_name/$peer_admin/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $peer_admin
cd ~/fabric-ca-client/$docker_tls_ca_name/$peer_admin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/tls/tls-ca-cert.pem


# *** ORGANIZATION CA CONFIG FOR $peer_admin IDENTITY ***
# Register and enroll the identity at the TLS-CA.
cd ~/fabric-ca-client/

echo
echo "Register & Enroll the " $peer_admin " -> " $docker_ca_name
echo

./fabric-ca-client register -d --id.name $peer_admin --id.secret $peer_admin_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type admin --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$peer_admin:"$peer_admin_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the key file to key.pem
mv $tempCert key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp/user/$peer_admin/msp/config.yaml
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

# *** PEER SETUP ***
echo
echo "Creating docker-container: " $docker_peer0_container_name " & " $docker_peer1_container_name
echo

cd ~/scripts/peers-compose
cat << EOT >> docker-compose.yaml
# Docker-compose file for the $docker_peer0 and $docker_peer1

version: '3.8'

networks:
  default:
    name: $docker_network

services:
  peer0-couchdb:
      image: couchdb:latest
      container_name: peer0-couchdb
      environment:
        - COUCHDB_USER=$docker_peer0_couchdb_username
        - COUCHDB_PASSWORD=$docker_peer0_couchdb_pass
      ports:
        - "5984:5984"


  $docker_peer0_service_name:
    image: hyperledger/fabric-peer:2.3
    container_name: $docker_peer0_container_name
    environment:
      - FABRIC_CFG_PATH=/etc/hyperledger/fabric
      - CORE_PEER_ID=$docker_peer0
      - CORE_PEER_NETWORKID=test
      - CORE_PEER_LISTENADDRESS=0.0.0.0:7061
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7062
      - CORE_PEER_CHAINCODEADDRESS=localhost:7062
      - CORE_PEER_ADDRESS=localhost:7061
      - CORE_PEER_MSPCONFIGPATH=msp
      - CORE_PEER_LOCALMSPID=$company
      - CORE_PEER_FILESYSTEMPATH=/var/hyperledger/production
      - CORE_PEER_GOSSIP_BOOTSTRAP=127.0.0.1:7071
      - CORE_PEER_GOSSIP_ENDPOINT=localhost:7061
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=localhost:7061
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CLIENTAUTHREQUIRED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/cert.pem
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/key.pem
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
      - CORE_PEER_TLS_CLIENTROOTCAS_FILES=tls/tls-ca-cert.pem
      - CORE_PEER_TLS_CLIENTCERT_FILE=/etc/hyperledger/fabric/msp/user/peer-admin/tls/cert.pem
      - CORE_PEER_TLS_CLIENTKEY_FILE=/etc/hyperledger/fabric/msp/user/peer-admin/tls/key.pem
      - CORE_PEER_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=peer0-couchdb:5984
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$docker_peer0_couchdb_username
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$docker_peer0_couchdb_pass
      - CORE_PEER_LEDGER_SNAPSHOTS=var/hyperledger/production/snapshots
      #- CORE_PEER_OPERATIONS_LISTENADDRESS=127.0.0.1:9443
      #- CORE_PEER_OPERATIONS_TLS_ENABLED=true
      #- CORE_PEER_OPERATIONS_TLS_CERT_FILE=
      #- CORE_PEER_OPERATIONS_TLS_KEY_FILE=
      #- CORE_PEER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
      - CORE_PEER_METRICS_PROVIDER=disabled
      #- CORE_PEER_METRICS_STATSD_ADDRESS=127.0.0.1:8125
      #- FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9444
    ports:
      - "7061:7061"
      - "7062:7062"
      - "7071:7071"
    volumes:
      - "~/container-volumes/$docker_peer0/production:/var/hyperledger/production"
      - "~/organizations/peerOrganizations/$company/peers/$docker_peer0/msp:/etc/hyperledger/fabric/msp"
      - "~/organizations/peerOrganizations/$company/peers/$docker_peer0/tls:/etc/hyperledger/fabric/tls"
    #depends_on:
      #- peer0-couchdb
    command: peer node start



  peer1-couchdb:
      image: couchdb:latest
      container_name: peer1-couchdb
      environment:
        - COUCHDB_USER=$docker_peer1_couchdb_username
        - COUCHDB_PASSWORD=$docker_peer1_couchdb_pass
      ports:
        - "5985:5984"


  $docker_peer1_service_name:
    image: hyperledger/fabric-peer:2.3
    container_name: $docker_peer1_container_name
    environment:
      - FABRIC_CFG_PATH=/etc/hyperledger/fabric
      - CORE_PEER_ID=$docker_peer1
      - CORE_PEER_NETWORKID=test
      - CORE_PEER_LISTENADDRESS=0.0.0.0:7081
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7082
      - CORE_PEER_CHAINCODEADDRESS=localhost:7082
      - CORE_PEER_ADDRESS=localhost:7081
      - CORE_PEER_MSPCONFIGPATH=msp
      - CORE_PEER_LOCALMSPID=$company
      - CORE_PEER_FILESYSTEMPATH=/var/hyperledger/production
      - CORE_PEER_GOSSIP_BOOTSTRAP=127.0.0.1:7091
      - CORE_PEER_GOSSIP_ENDPOINT=localhost:7081
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=localhost:7081
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CLIENTAUTHREQUIRED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/cert.pem
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/key.pem
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
      - CORE_PEER_TLS_CLIENTROOTCAS_FILES=tls/tls-ca-cert.pem
      - CORE_PEER_TLS_CLIENTCERT_FILE=/etc/hyperledger/fabric/tls/cert.pem
      - CORE_PEER_TLS_CLIENTKEY_FILE=/etc/hyperledger/fabric/tls/key.pem
      - CORE_PEER_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=peer1-couchdb:5985
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$docker_peer1_couchdb_username
      - CORE_PEER_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$docker_peer1_couchdb_pass
      - CORE_PEER_LEDGER_SNAPSHOTS=var/hyperledger/production/snapshots
      #- CORE_PEER_OPERATIONS_LISTENADDRESS=127.0.0.1:9443
      #- CORE_PEER_OPERATIONS_TLS_ENABLED=true
      #- CORE_PEER_OPERATIONS_TLS_CERT_FILE=
      #- CORE_PEER_OPERATIONS_TLS_KEY_FILE=
      #- CORE_PEER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
      - CORE_PEER_METRICS_PROVIDER=disabled
      #- CORE_PEER_METRICS_STATSD_ADDRESS=127.0.0.1:8125
      #- FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9444
    ports:
      - "7081:7081"
      - "7082:7082"
      - "7091:7091"
    volumes:
      - "~/container-volumes/$docker_peer1/production:/var/hyperledger/production"
      - "~/organizations/peerOrganizations/$company/peers/$docker_peer1/msp:/etc/hyperledger/fabric/msp"
      - "~/organizations/peerOrganizations/$company/peers/$docker_peer1/tls:/etc/hyperledger/fabric/tls"
    #depends_on:
      #- peer1-couchdb
    command: peer node start
EOT

docker-compose up -d
#================================================================================================================================================================================================================================================================================

# Create admin-client certs on orderer CA (we use company-CA for now)
mkdir ~/admin-client

echo
echo "Register & Enroll the admin-client -> " $docker_tls_ca_name
echo

cd ~/fabric-ca-client
./fabric-ca-client register -d --id.name admin-client --id.secret admin-client-Welkom01! -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type admin --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://admin-client:"admin-client-Welkom01!"@localhost:7054 --mspdir $docker_tls_ca_name/admin-client/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

cd ~/fabric-ca-client/$docker_tls_ca_name/admin-client/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the TLS-key file to key.pem
mv $tempCert admin-client-tls-key.pem

cp ~/fabric-ca-client/$docker_tls_ca_name/admin-client/msp/keystore/admin-client-tls-key.pem ~/admin-client/
cp ~/fabric-ca-client/$docker_tls_ca_name/admin-client/msp/signcerts/cert.pem ~/admin-client/
mv ~/admin-client/cert.pem ~/admin-client/admin-client-tls-cert.pem
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/admin-client/tls-ca-cert.pem

#================================================================================================================================================================================================================================================================================

# *** TLS CONFIG FOR $docker_orderer0 IDENTITY ***
# Register and enroll the identity at the TLS-CA.

echo
echo "Register & Enroll the " $docker_orderer0 " -> " $docker_tls_ca_name
echo

cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name $docker_orderer0 --id.secret $docker_orderer0_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer0:"$docker_orderer0_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$docker_orderer0/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity $docker_orderer0
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/
cp ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer0/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $docker_orderer0
cd ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer0/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/tls/tls-ca-cert.pem

# ENROLL TO THE organization-CA (CA) --> NORMALY IT HAS ITS OWN CA

echo
echo "Register & Enroll the " $docker_orderer0 " -> " $docker_ca_name
echo

cd ~/fabric-ca-client
./fabric-ca-client register -d --id.name $docker_orderer0 --id.secret $docker_orderer0_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer0:"$docker_orderer0_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Changing to key.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the TLS-key file to key.pem
mv $tempCert $docker_orderer0-key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_orderer0/msp/config.yaml
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

# *** TLS CONFIG FOR $docker_orderer1 IDENTITY ***
# Register and enroll the identity at the TLS-CA.

echo
echo "Register & Enroll the " $docker_orderer1 " -> " $docker_tls_ca_name
echo

cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name $docker_orderer1 --id.secret $docker_orderer1_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer1:"$docker_orderer1_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$docker_orderer1/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity $docker_orderer1
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/
cp ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer1/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $docker_orderer1
cd ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer1/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/tls/tls-ca-cert.pem

# ENROLL TO THE organization-CA (CA) --> NORMALY IT HAS ITS OWN CA

echo
echo "Register & Enroll the " $docker_orderer1 " -> " $docker_ca_name
echo

cd ~/fabric-ca-client
./fabric-ca-client register -d --id.name $docker_orderer1 --id.secret $docker_orderer1_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer1:"$docker_orderer1_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Changing to key.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the TLS-key file to key.pem
mv $tempCert $docker_orderer1-key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_orderer1/msp/config.yaml
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

# *** TLS CONFIG FOR $docker_orderer2 IDENTITY ***
# Register and enroll the identity at the TLS-CA.

echo
echo "Register & Enroll the " $docker_orderer2 " -> " $docker_tls_ca_name
echo

cd ~/fabric-ca-client/
./fabric-ca-client register -d --id.name $docker_orderer2 --id.secret $docker_orderer2_pass -u https://localhost:7054 --mspdir $docker_tls_ca_name/$tls_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer2:"$docker_orderer2_pass"@localhost:7054 --mspdir $docker_tls_ca_name/$docker_orderer2/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Copy the public key of the identity $docker_orderer2
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/
cp ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer2/msp/signcerts/cert.pem tls/

# Copy the private key of the identity $docker_orderer2
cd ~/fabric-ca-client/$docker_tls_ca_name/$docker_orderer2/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the TLS-key file to key.pem
mv $tempCert key.pem
cp key.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/tls/key.pem

# Copy the public key of the TLS-CA server for tls coms.
cp ~/container-volumes/$docker_tls_ca_name/ca-cert.pem ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/tls/tls-ca-cert.pem

# ENROLL TO THE organization-CA (CA) --> NORMALY IT HAS ITS OWN CA

echo
echo "Register & Enroll the " $docker_orderer2 " -> " $docker_ca_name
echo

cd ~/fabric-ca-client
./fabric-ca-client register -d --id.name $docker_orderer2 --id.secret $docker_orderer2_pass -u https://localhost:7055 --mspdir $docker_ca_name/$ca_admin/msp --id.type orderer --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts "$hostname,localhost"
./fabric-ca-client enroll -u https://$docker_orderer2:"$docker_orderer2_pass"@localhost:7055 --mspdir ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/msp --csr.hosts "$hostname,localhost" --tls.certfiles tls-root-cert/tls-ca-cert.pem

# Changing to key.pem
cd ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/msp/keystore/
tempCert="$(ls -t * | head -1)"
# Changing the name of the TLS-key file to key.pem
mv $tempCert $docker_orderer2-key.pem

cat << EOT >> ~/organizations/peerOrganizations/$company/peers/$docker_orderer2/msp/config.yaml
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


echo
echo "Creating docker-container: " $docker_orderer0_container_name " & " $docker_orderer1_container_name " & " $docker_orderer2_container_name
echo

cd ~/scripts/orderer-compose
cat << EOT >> docker-compose.yaml
version: '3.8'

networks:
  default:
    name: $docker_network

services:

  $docker_orderer0_service_name:
    image: hyperledger/fabric-orderer:2.3
    container_name: $docker_orderer0_container_name
    environment:
      - FABRIC_CFG_PATH=/etc/hyperledger/fabric
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7040
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=tls/key.pem
      - ORDERER_GENERAL_TLS_CERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_TLS_ROOTCAS=tls/tls-ca-cert.pem
      - ORDERER_GENERAL_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_GENERAL_TLS_CLIENTROOTCAS=tls/tls-ca-cert.pem
      # KEEPALIVE SETTINGS SHOULD NOT BE OVERRIDDEN
      - ORDERER_GENERAL_KEEPALIVE_SERVERMININTERVAL=60s
      - ORDERER_GENERAL_KEEPALIVE_SERVERINTERVAL=7200s
      - ORDERER_GENERAL_KEEPALIVE_SERVERTIMEOUT=20s
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=tls/key.pem
      # CLUSTER SETTINGS NEED TO BE SET TOGETHER
      #- ORDERER_GENERAL_CLUSTER_LISTENPORT=
      #- ORDERER_GENERAL_CLUSTER_LISTENADDRESS=
      #- ORDERER_GENERAL_CLUSTER_SERVERCERTIFICATE=
      #- ORDERER_GENERAL_CLUSTER_SERVERPRIVATEKEY=
      - ORDERER_GENERAL_BOOTSTRAPMETHOD=none
      - ORDERER_GENERAL_LOCALMSPDIR=msp
      - ORDERER_GENERAL_LOCALMSPID=$company
      - ORDERER_FILELEDGER_LOCATION=/var/hyperledger/production/orderer
      #- ORDERER_OPERATIONS_LISTENADDRESS=127.0.0.1:8443
      #- ORDERER_OPERATIONS_TLS_ENABLED=true
      #- ORDERER_OPERATIONS_TLS_CERTIFICATE=tls/cert.pem
      #- ORDERER_OPERATIONS_TLS_PRIVATEKEY=tls/key.pem
      #- ORDERER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
      #- ORDERER_OPERATIONS_TLS_CLIENTROOTCAS=tls/tls-ca-root.pem
      #- ORDERER_METRICS_PROVIDER=disabled
      #- ORDERER_METRICS_STATSD_ADDRESS=127.0.0.1:8125
      - ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:9440
      - ORDERER_ADMIN_TLS_ENABLED=true
      - ORDERER_ADMIN_TLS_CERTIFICATE=/etc/hyperledger/fabric/tls/cert.pem
      - ORDERER_ADMIN_TLS_PRIVATEKEY=/etc/hyperledger/fabric/tls/key.pem
      - ORDERER_ADMIN_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_ADMIN_TLS_CLIENTROOTCAS=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
      - ORDERER_CHANNELPARTICIPATION_ENABLED=true
      #- ORDERER_CHANNELPARTICIPATION_MAXREQUESTBODYSIZE=1 MB
      - ORDERER_CONSENSUS_WALDIR=/var/hyperledger/production/orderer/etcdraft/wal
      - ORDERER_CONSENSUS_SNAPDIR=/var/hyperledger/production/orderer/etcdraft/snapshot

    ports:
      - "7040:7040"
      - "9440:9440"
    volumes:
      - "~/container-volumes/$docker_orderer0/production:/var/hyperledger/production"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer0/msp:/etc/hyperledger/fabric/msp"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer0/tls:/etc/hyperledger/fabric/tls"
    command: orderer start


  $docker_orderer1_service_name:
    image: hyperledger/fabric-orderer:2.3
    container_name: $docker_orderer1_container_name
    environment:
      - FABRIC_CFG_PATH=/etc/hyperledger/fabric
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7041
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=tls/key.pem
      - ORDERER_GENERAL_TLS_CERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_TLS_ROOTCAS=tls/tls-ca-cert.pem
      - ORDERER_GENERAL_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_GENERAL_TLS_CLIENTROOTCAS=tls/tls-ca-cert.pem
      # KEEPALIVE SETTINGS SHOULD NOT BE OVERRIDDEN
      - ORDERER_GENERAL_KEEPALIVE_SERVERMININTERVAL=60s
      - ORDERER_GENERAL_KEEPALIVE_SERVERINTERVAL=7200s
      - ORDERER_GENERAL_KEEPALIVE_SERVERTIMEOUT=20s
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=tls/key.pem
      # CLUSTER SETTINGS NEED TO BE SET TOGETHER
      #- ORDERER_GENERAL_CLUSTER_LISTENPORT=
      #- ORDERER_GENERAL_CLUSTER_LISTENADDRESS=
      #- ORDERER_GENERAL_CLUSTER_SERVERCERTIFICATE=
      #- ORDERER_GENERAL_CLUSTER_SERVERPRIVATEKEY=
      - ORDERER_GENERAL_BOOTSTRAPMETHOD=none
      - ORDERER_GENERAL_LOCALMSPDIR=msp
      - ORDERER_GENERAL_LOCALMSPID=$company
      - ORDERER_FILELEDGER_LOCATION=/var/hyperledger/production/orderer
      #- ORDERER_OPERATIONS_LISTENADDRESS=127.0.0.1:8443
      #- ORDERER_OPERATIONS_TLS_ENABLED=true
      #- ORDERER_OPERATIONS_TLS_CERTIFICATE=tls/cert.pem
      #- ORDERER_OPERATIONS_TLS_PRIVATEKEY=tls/key.pem
      #- ORDERER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
      #- ORDERER_OPERATIONS_TLS_CLIENTROOTCAS=tls/tls-ca-root.pem
      #- ORDERER_METRICS_PROVIDER=disabled
      #- ORDERER_METRICS_STATSD_ADDRESS=127.0.0.1:8125
      - ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:9441
      - ORDERER_ADMIN_TLS_ENABLED=true
      - ORDERER_ADMIN_TLS_CERTIFICATE=/etc/hyperledger/fabric/tls/cert.pem
      - ORDERER_ADMIN_TLS_PRIVATEKEY=/etc/hyperledger/fabric/tls/key.pem
      - ORDERER_ADMIN_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_ADMIN_TLS_CLIENTROOTCAS=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
      - ORDERER_CHANNELPARTICIPATION_ENABLED=true
      #- ORDERER_CHANNELPARTICIPATION_MAXREQUESTBODYSIZE=1 MB
      - ORDERER_CONSENSUS_WALDIR=/var/hyperledger/production/orderer/etcdraft/wal
      - ORDERER_CONSENSUS_SNAPDIR=/var/hyperledger/production/orderer/etcdraft/snapshot

    ports:
      - "7041:7041"
      - "9441:9441"
    volumes:
      - "~/container-volumes/$docker_orderer1/production:/var/hyperledger/production"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer1/msp:/etc/hyperledger/fabric/msp"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer1/tls:/etc/hyperledger/fabric/tls"
    command: orderer start


  $docker_orderer2_service_name:
    image: hyperledger/fabric-orderer:2.3
    container_name: $docker_orderer2_container_name
    environment:
      - FABRIC_CFG_PATH=/etc/hyperledger/fabric
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7042
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=tls/key.pem
      - ORDERER_GENERAL_TLS_CERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_TLS_ROOTCAS=tls/tls-ca-cert.pem
      - ORDERER_GENERAL_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_GENERAL_TLS_CLIENTROOTCAS=tls/tls-ca-cert.pem
      # KEEPALIVE SETTINGS SHOULD NOT BE OVERRIDDEN
      - ORDERER_GENERAL_KEEPALIVE_SERVERMININTERVAL=60s
      - ORDERER_GENERAL_KEEPALIVE_SERVERINTERVAL=7200s
      - ORDERER_GENERAL_KEEPALIVE_SERVERTIMEOUT=20s
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=tls/cert.pem
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=tls/key.pem
      # CLUSTER SETTINGS NEED TO BE SET TOGETHER
      #- ORDERER_GENERAL_CLUSTER_LISTENPORT=
      #- ORDERER_GENERAL_CLUSTER_LISTENADDRESS=
      #- ORDERER_GENERAL_CLUSTER_SERVERCERTIFICATE=
      #- ORDERER_GENERAL_CLUSTER_SERVERPRIVATEKEY=
      - ORDERER_GENERAL_BOOTSTRAPMETHOD=none
      - ORDERER_GENERAL_LOCALMSPDIR=msp
      - ORDERER_GENERAL_LOCALMSPID=$company
      - ORDERER_FILELEDGER_LOCATION=/var/hyperledger/production/orderer
      #- ORDERER_OPERATIONS_LISTENADDRESS=127.0.0.1:8443
      #- ORDERER_OPERATIONS_TLS_ENABLED=true
      #- ORDERER_OPERATIONS_TLS_CERTIFICATE=tls/cert.pem
      #- ORDERER_OPERATIONS_TLS_PRIVATEKEY=tls/key.pem
      #- ORDERER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
      #- ORDERER_OPERATIONS_TLS_CLIENTROOTCAS=tls/tls-ca-root.pem
      #- ORDERER_METRICS_PROVIDER=disabled
      #- ORDERER_METRICS_STATSD_ADDRESS=127.0.0.1:8125
      - ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:9442
      - ORDERER_ADMIN_TLS_ENABLED=true
      - ORDERER_ADMIN_TLS_CERTIFICATE=/etc/hyperledger/fabric/tls/cert.pem
      - ORDERER_ADMIN_TLS_PRIVATEKEY=/etc/hyperledger/fabric/tls/key.pem
      - ORDERER_ADMIN_TLS_CLIENTAUTHREQUIRED=true
      - ORDERER_ADMIN_TLS_CLIENTROOTCAS=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
      - ORDERER_CHANNELPARTICIPATION_ENABLED=true
      #- ORDERER_CHANNELPARTICIPATION_MAXREQUESTBODYSIZE=1 MB
      - ORDERER_CONSENSUS_WALDIR=/var/hyperledger/production/orderer/etcdraft/wal
      - ORDERER_CONSENSUS_SNAPDIR=/var/hyperledger/production/orderer/etcdraft/snapshot

    ports:
      - "7042:7042"
      - "9442:9442"
    volumes:
      - "~/container-volumes/$docker_orderer2/production:/var/hyperledger/production"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer2/msp:/etc/hyperledger/fabric/msp"
      - "~/organizations/peerOrganizations/$company/peers/$docker_orderer2/tls:/etc/hyperledger/fabric/tls"
    command: orderer start
EOT

#================================================================================================================================================================================================================================================================================

docker-compose up -d


cd
echo
docker ps -a

