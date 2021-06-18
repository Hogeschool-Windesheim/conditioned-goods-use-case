# Hyperledger Fabric production network
Hyperledger Fabric scripts that can be used to deploy a multi-node Hyperledger Fabric production network. The scripts are based on Hyperledger Fabric version 2.3.

## Hardware
The scripts are tested on two Ubuntu 20.04 servers with docker version 20.10.4. Both servers contained 2048MB ram and two CPU's. 

## Getting Started
The steps below will help you setup a working Hyperledger Fabric multi-node production network, including chaincode. 

### Prerequisites
- Docker & docker-compose;
- Git;
- Node;
- NPM;

All prerequisites can be downloaded by running the 'Hyperledger-prereq.sh' script. 

### Docker Swarm
Docker swarm is used to connect all docker containers. Run the command 'Docker swarm init' on the Docker Swarm Manager Node to create a new swarm service. This command results in a worker join token. Run this token on the second server to join the swarm network. 

After this a overlay network needs to be created. The overlay network name used in the scripts is 'Kontgoods'. To create an overlay network with this name the command 'docker network create --driver overlay --subnet=10.200.1.0/24 --attachable Kontgoods' needs to be run on the docker swarm manager. 

You can check if the overlay network is running by executing the command 'docker network ls'. 

### SCRIPTS
After creating a docker swarm network you can run the scripts to create a production network. 
You need to run the scripts in the following order (Only the move_crypto script needs to be run on both servers, the other scripts can be run on the docker swarm manager):
1. ./move_crypto.sh
2. ./populate_hostname.sh (the hostnames first need to be set in the .env file, and on the servers itself)
3. ./scripts/network/deploy_services_kafka.sh
4. ./scripts/network/deploy_services_org1.sh
5. ./scripts/network/deploy_services_org2.sh

Check if all docker containers are running (docker service ls | grep "0/1") and connected (docker service logs <container id>).
If all containers are running and connected you can create a channel.

6. ./scripts/create_channel.sh

### CHAINCODE
The chaincode can be found in the folder 'chaincode'. It needs to be build before using it (you can do this using the visual studio code extension 'IBM's blockchain platform). To do this you need to open the chaincode folder in visual studio code, open the IBM extension, open the eclipses next to SMART CONTRACTS and click 'Package Open Project'.   
The chaincode will handle all the business logic of the blockchain network. 

#### Copy Chaincode
To install the chaincode it first needs to be copied to the Docker Swarm Manager Node with a .gz extension. The chaincode can then be copied to the CLI-peer with the command 'docker cp (chaincode package) (docker container):(docker container path)' for example 'docker cp basic.gz hlf_services_cli.1.m6zkc7fcy2pdxws2yp6senv0b:/opt/gopath/src/github.com/hyperledger/fabric/peer'. 

#### Connecting to the peers
After copying the chaincode to the CLI-peer it needs to be installed on all peers in the blockchain. To connect to a peer use the command 'docker exec -it (container name) (shell name)' for example 'Docker exec -it peer0.org1.example.com bash'. 

**NOTE: The step above and all steps below need to be executed on 1 peer from each organization. 

#### Setting variables
After this you need to set the variables. An example for organization 1 can be found below.

export CORE_PEER_TLS_ENABLED=true
  
export CORE_PEER_LOCALMSPID="Org1MSP"
  
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/
  
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

##### Installing the chaincode
After the above mentioned steps you can install the chaincode with the command 'peer lifecycle chaincode install <chaincode package>' 
  
  
##### Approving the chaincode
  
  
##### Committing the chaincode











