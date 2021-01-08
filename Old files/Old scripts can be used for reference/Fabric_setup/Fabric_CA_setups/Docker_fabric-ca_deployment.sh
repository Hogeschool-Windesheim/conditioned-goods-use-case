#!/bin/bash

# Make sure to run fabric_testnetwork_p1.sh first

cd ~/

docker pull hyperledger/fabric-ca:latest

touch docker-compose.yaml
cat <<EOT >> docker-compose.yaml
fabric-ca-server:
  image: hyperledger/fabric-ca:latest
  container_name: Spark-TLS-CA
  ports:
    - "7054:7054"
  environment:
    - FABRIC_CA_HOME=/etc/hyperledger/Spark-TLS-CA
  volumes:
    - "./fabric-ca-server:/etc/hyperledger/Spark-TLS-CA"
  command: sh -c 'fabric-ca-server start -b tls-admin:tls-Welkom01!'
EOT


