import * as fabricNetwork from 'fabric-network';
import {SmartContractUtil} from './ts-smart-contract-util';

import * as os from 'os';
import * as path from 'path';

import {toObject} from '../src/helpers';
import Shipment from '../src/models/Shipment';

describe('ShipmentContract-blockchain-backend@1.0.0' , () => {
    const homedir: string = os.homedir();
    const walletPath: string = path.join(homedir, '.fabric-vscode', 'v2', 'environments', 'blockchain', 'wallets', 'Org1');
    const gateway: fabricNetwork.Gateway = new fabricNetwork.Gateway();
    let fabricWallet: fabricNetwork.Wallet;
    const identityName: string = 'Org1 Admin';
    let connectionProfile: any;

    beforeAll(async () => {
        connectionProfile = await SmartContractUtil.getConnectionProfile();
        fabricWallet = await fabricNetwork.Wallets.newFileSystemWallet(walletPath);
    });

    beforeEach(async () => {
        const discoveryAsLocalhost: boolean = SmartContractUtil.hasLocalhostURLs(connectionProfile);
        const discoveryEnabled: boolean = true;

        const options: fabricNetwork.GatewayOptions = {
            discovery: {
                asLocalhost: discoveryAsLocalhost,
                enabled: discoveryEnabled,
            },
            identity: identityName,
            wallet: fabricWallet,
        };

        await gateway.connect(connectionProfile, options);
    });

    afterEach(async () => {
        gateway.disconnect();
    });

    describe('AddShipment', () => {
        it('should submit AddShipment transaction', async () => {
            const response: Buffer = await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['1'], gateway);

            const shipment = toObject<Shipment>(response);

            const expected: Shipment = {
                id: '1',
                sensors: [],
            }

            expect(shipment).toEqual(expected);
        });
    });

    describe('UpdateShipment', () => {
        it('should submit UpdateShipment transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['2'], gateway);

            const response: Buffer = await SmartContractUtil.submitTransaction('ShipmentContract', 'UpdateShipment', ['2'], gateway);
            
            const shipment = toObject<Shipment>(response);

            const expected: Shipment = {
                id: '2',
                sensors: [],
            }

            expect(shipment).toEqual(expected);
        });
    });

    describe('GetShipment', () => {
        it('should submit GetShipment transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['3'], gateway);

            const response: Buffer = await SmartContractUtil.evaluateTransaction('ShipmentContract', 'GetShipment', ['3'], gateway);
            
            const shipment = toObject<Shipment>(response);

            const expected: Shipment = {
                id: '3',
                sensors: [],
            }

            expect(shipment).toEqual(expected);
        });
    });

    describe('ShipmentExist', () => {
        it('should evaluate ShipmentExist transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['4'], gateway);

            const response: Buffer = await SmartContractUtil.evaluateTransaction('ShipmentContract', 'ShipmentExist', ['4'], gateway);

            const exist = toObject<boolean>(response);

            expect(exist).toEqual(true);
        });
    });

    describe('GetShipments', () => {
        it('should submit GetShipments transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['5'], gateway);

            const response: Buffer = await SmartContractUtil.evaluateTransaction('ShipmentContract', 'GetShipments', [], gateway);
            
            const shipment = toObject<Array<Shipment>>(response);

            const expected: Shipment = {
                id: '5',
                sensors: [],
            };

            expect(shipment).toContainEqual(expected);
        });
    });

    describe('RegisterSensor', () => {
        it('should submit RegisterSensor transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['6'], gateway);

            const response: Buffer = await SmartContractUtil.submitTransaction('ShipmentContract', 'RegisterSensor', ['6', '1'], gateway);
            
            const hasRegistered = toObject<boolean>(response);

            expect(hasRegistered).toEqual(true);
        });
    });

    describe('HasSensor', () => {
        it('should submit HasSensor transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['7'], gateway);

            // Add Sensor
            await SmartContractUtil.submitTransaction('ShipmentContract', 'RegisterSensor', ['6', '1'], gateway);

            const response: Buffer = await SmartContractUtil.evaluateTransaction('ShipmentContract', 'HasSensor', ['6', '1'], gateway);
            
            const hasSensor = toObject<boolean>(response);

            expect(hasSensor).toEqual(true);
        });
    });
});
