// import org1 from '../Api/src/profiles/org1.json'
// const org1 = require('../Api/src/profiles/org1.json')
import {Gateway, Wallets} from 'fabric-network';
import * as os from 'os';
import * as path from 'path';

const org1 = {
    "certificateAuthorities": {
        "org1ca-api.127-0-0-1.nip.io:8081": {
            "url": "http://org1ca-api.127-0-0-1.nip.io:8081"
        }
    },
    "client": {
        "connection": {
            "timeout": {
                "orderer": "300",
                "peer": {
                    "endorser": "300"
                }
            }
        },
        "organization": "Org1"
    },
    "display_name": "Org1 Gateway",
    "id": "org1gateway",
    "name": "Org1 Gateway",
    "organizations": {
        "Org1": {
            "certificateAuthorities": [
                "org1ca-api.127-0-0-1.nip.io:8081"
            ],
            "mspid": "Org1MSP",
            "peers": [
                "org1peer-api.127-0-0-1.nip.io:8081"
            ]
        }
    },
    "peers": {
        "org1peer-api.127-0-0-1.nip.io:8081": {
            "grpcOptions": {
                "grpc.default_authority": "org1peer-api.127-0-0-1.nip.io:8081",
                "grpc.ssl_target_name_override": "org1peer-api.127-0-0-1.nip.io:8081"
            },
            "url": "grpc://org1peer-api.127-0-0-1.nip.io:8081"
        }
    },
    "type": "gateway",
    "version": "1.0"
};

export async function connect() {
    const walletPath = path.join(os.homedir(), '.fabric-vscode', 'v2', 'environments', 'blockchain', 'wallets', 'Org1');

    // Create new wallet
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    // Initialize a new gateway.
    const gateway = new Gateway();

    // Gateway options
    const options = {
        discovery: {
            asLocalhost: true,
            enabled: true,
        },
        identity: 'Org1 Admin',
        wallet,
    };

    // Connect to peer
    
    try {
        await gateway.connect(org1, options);
        const network = await gateway.getNetwork('mychannel');
        const contract = network.getContract('blockchain-backend');
        await contract.submitTransaction('AddShipment', `1`);
        await contract.submitTransaction('RegisterSensor', `1`, `1`);
     
    
        
        for (let i = 0; i < 10; i++) {
            let value = Math.round(-Math.random() * (28 - 4) + 4);
            await contract.submitTransaction('AddMeasurement', 'MeasurementContract', '7', '1', `${value}`, `${new Date()}`);
        }
        console.log(value);
    }
    catch (error) {
        console.log(error);
    }
}

connect();








