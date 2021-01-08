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
sed -i '427s\.*\    url: https://rcaadmin:"rca-Welkom01!"@localhost:7055\' fabric-ca-server-config.yaml
sed -i '428s\.*\    caname: Spark!LivingLab-Org1-CA\' fabric-ca-server-config.yaml
sed -i '431s\.*\    hosts: localhost\' fabric-ca-server-config.yaml
sed -i '432s\.*\    profile: ca\' fabric-ca-server-config.yaml
sed -i '436s\.*\    certfiles: tls/tls-ca-cert.pem\' fabric-ca-server-config.yaml
sed -i '460s\.*\    listenAddress: 127.0.0.1:9445\' fabric-ca-server-config.yaml

# Remove cert-ca.pem and msp folder to be regenerated during startup
rm ~/fabric-ca-server-int-ca/ca-cert.pem
sudo rm -rf ~/fabric-ca-server-int-ca/msp

./fabric-ca-server start