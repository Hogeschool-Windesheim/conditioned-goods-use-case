#!/bin/bash

# Default port: 7054
# Default password: Welkom01!
# fabric-ca-server-tls username:password --> tls-admin:tls-Welkom01!

# fabric-ca-server-tls name: Spark!LivingLab-CA

# Organization CA bootstrap ID
# username: rcaadmin
# password: rca-Welkom01!

# username: icaadmin
# password: ica-Welkom01!

# Usefull info
# If you are using LDAP server for your user registry, then the register step is not required because the identities already exist in the LDAP database

wget https://github.com/hyperledger/fabric-ca.git
tar -xzf hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz

mkdir fabric-ca-client
cd fabric-ca-client
mkdir tls-ca org1-ca int-ca

mkdir tls-root-cert

echo 'export FABRIC_CA_CLIENT_HOME=/home/robin/fabric-ca-client' >> ~/.profile
echo 'export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/robin/fabric-ca-client/tls-root-cert' >> ~/.profile
source ~/.profile

cd
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

cd fabric-ca-client/
# Link to section below: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#enroll-bootstrap-user-with-tls-ca
# ./fabric-ca-client enroll -d -u https://<ADMIN>:<ADMIN-PWD>@<CA-URL>:<PORT> --tls.certfiles <RELATIVE-PATH-TO-TLS-CERT> --enrollment.profile tls --csr.hosts '<CA_HOSTNAME>' --mspdir tls-ca/tlsadmin/msp
./fabric-ca-client enroll -d -u https://tls-admin:'tls-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20, localhost' --mspdir tls-ca/tlsadmin/msp


# To enroll the organization CA, first register the organization CA
./fabric-ca-client register -d --id.name rcaadmin --id.secret rca-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
# Enroll the rcaadmin
./fabric-ca-client enroll -d -u https://rcaadmin:'rca-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20,localhost' --mspdir tls-ca/rcaadmin/msp

# Setting temporary variable to the key file in rcaadmin/msp/keystore
cd ~/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/$tempCert ~/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/key.pem

cd ~/fabric-ca-client/
# Optional register intermediate CA
./fabric-ca-client register -d --id.name icaadmin --id.secret ica-Welkom01! -u https://localhost:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
# Enroll the icaadmin
./fabric-ca-client enroll -d -u https://icaadmin:'ica-Welkom01!'@localhost:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'Ubuntu-20, localhost' --mspdir tls-ca/icaadmin/msp



# ***DEPLOYING THE ORGANIZATION CA ***
# Info: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#deploy-an-organization-ca

# Creating folder and copying binary file (fabric-ca-server) to folder fabric-ca-server-org1
cd
mkdir fabric-ca-server-org1
cp Downloads/bin/fabric-ca-server fabric-ca-server-org1/

# Creating TLS folder and copying needed certificates
cd fabric-ca-server-org1
mkdir tls


cp ../fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem tls
cp ../fabric-ca-client/tls-ca/rcaadmin/msp/keystore/key.pem tls

# Init the server-org1
./fabric-ca-server init -b rcaadmin:rca-Welkom01!

# Edit the 'fabric-ca-server-config.yaml' file
# change port: 7055

# change tls to true
# change tls certfile: tls/cert.pem
# change tls keyfile: tls/key.pem

# change CA name: Spark!LivingLab-Org1-CA
# change the operations.listenAddress: 127.0.0.1:9444

# Before starting the server, if you modified any of the values in the csr block of the configuration .yaml file, you need to delete the fabric-ca-server-org1/ca-cert.pem file and the entire fabric-ca-server-org1/msp folder. These certificates will be re-generated based on the new settings in the configuration .yaml file when you start the CA server in the next step.
rm ~/fabric-ca-server-org1/cert-ca.pem
sudo rm -rf ~/fabric-ca-server-org1/msp

./fabric-ca-server start

cd ~/fabric-ca-client/
# Enroll the rcaadmin to Spark!LivingLab-Org1-CA
./fabric-ca-client enroll -d -u https://rcaadmin:"rca-Welkom01!"@localhost:7055 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'Ubuntu-20,localhost' --mspdir org1-ca/rcaadmin/msp

# Setting temporary variable to the key file in rcaadmin/msp/keystore
cd ~/fabric-ca-client/org1-ca/rcaadmin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to org1-key.pem
mv ~/fabric-ca-client/org1-ca/rcaadmin/msp/keystore/$tempCert ~/fabric-ca-client/org1-ca/rcaadmin/msp/keystore/org1-key.pem

cd ~/fabric-ca-client/

# Register the icaadmin to the Spark!LivingLab-Org1-CA
./fabric-ca-client register -u https://localhost:7055  --id.name icaadmin --id.secret ica-Welkom01! --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir org1-ca/rcaadmin/msp



# ***DEPLOYING THE INTERMEDIATE CA *** --> WORKING
# Info: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#optional-deploy-an-intermediate-ca

# Creating folder and copying binary file (fabric-ca-server) to folder fabric-ca-server-int-ca
cd
mkdir fabric-ca-server-int-ca
cp Downloads/bin/fabric-ca-server fabric-ca-server-int-ca/

# Creating TLS folder and copying needed certificates
cd fabric-ca-server-int-ca
mkdir tls

# Setting temporary variable to the key file in icaadmin/msp/keystore
cd ~/fabric-ca-client/tls-ca/icaadmin/msp/keystore/
tempCert="$(ls -t * | head -1)"

# Changing the name of the key file to key.pem
mv ~/fabric-ca-client/tls-ca/icaadmin/msp/keystore/$tempCert ~/fabric-ca-client/tls-ca/icaadmin/msp/keystore/key.pem

# Copying the icaadmin TLS-certificate and private key
cd fabric-ca-server-int-ca
cp ../fabric-ca-client/tls-ca/icaadmin/msp/signcerts/cert.pem tls
cp ../fabric-ca-client/tls-ca/icaadmin/msp/keystore/key.pem tls

# Copying TLS CA root certificate to intermediate CA
cp ../fabric-ca-server-tls/ca-cert.pem tls/tls-ca-cert.pem

# Init the fabric-ca-server-int-ca
./fabric-ca-server init -b icaadmin:ica-Welkom01!

# Setting the config in ~/fabric-ca-server-int-ca/fabric-ca-server-config.yaml
sed -i '43s\.*\port: 7056\' fabric-ca-server-config.yaml
sed -i '69s\.*\  enabled: true\' fabric-ca-server-config.yaml
sed -i '71s\.*\  certfile: tls/cert.pem\' fabric-ca-server-config.yaml
sed -i '72s\.*\  keyfile: tls/key.pem\' fabric-ca-server-config.yaml
sed -i '89s\.*\  name: Spark!LivingLab-int-CA\' fabric-ca-server-config.yaml
sed -i '281s\.*\           maxpathlen: 0\' fabric-ca-server-config.yaml
sed -i '310s\.*\   cn: \' fabric-ca-server-config.yaml
sed -i '325s\.*\      pathlength: 0\' fabric-ca-server-config.yaml
sed -i '427s\.*\    url: https://rcaadmin:'rca-Welkom01!'@localhost:7055\' fabric-ca-server-config.yaml
sed -i '428s\.*\    caname: Spark!LivingLab-Org1-CA\' fabric-ca-server-config.yaml
sed -i '431s\.*\    hosts: localhost\' fabric-ca-server-config.yaml
sed -i '432s\.*\    profile: ca\' fabric-ca-server-config.yaml
sed -i '436s\.*\    certfiles: tls/tls-ca-cert.pem\' fabric-ca-server-config.yaml
sed -i '460s\.*\    listenAddress: 127.0.0.1:9445\' fabric-ca-server-config.yaml

# Remove cert-ca.pem and msp folder to be regenerated during startup
rm ~/fabric-ca-server-int-ca/ca-cert.pem
sudo rm -rf ~/fabric-ca-server-int-ca/msp

./fabric-ca-server start



# Enroll the Intermediate CA admin
# Info: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#enroll-the-intermediate-ca-admin

./fabric-ca-client enroll -d -u https://icaadmin:'ica-Welkom01!'@localhost:7056 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'Ubuntu-20,localhost' --mspdir int-ca/icaadmin/msp

# HIER VERDER: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#next-steps