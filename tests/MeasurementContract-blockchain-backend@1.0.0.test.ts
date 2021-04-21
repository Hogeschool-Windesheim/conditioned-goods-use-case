import * as assert from 'assert';
import * as fabricNetwork from 'fabric-network';
import { SmartContractUtil } from './ts-smart-contract-util';

import * as os from 'os';
import * as path from 'path';

import {toObject} from '../src/helpers';
import Measurement from '../src/models/Measurement';
import Shipment from '../src/models/Shipment';

describe('MeasurementContract-blockchain-backend@1.0.0' , () => {
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

    describe('AddMeasurement', () => {
        it('should submit AddMeasurement transaction', async () => {
            // Add shipment
            await SmartContractUtil.submitTransaction('ShipmentContract', 'AddShipment', ['7'], gateway);
            
            // Register sensor
            await SmartContractUtil.submitTransaction('ShipmentContract', 'RegisterSensor', ['7','1'], gateway);

            const response: Buffer = await SmartContractUtil.submitTransaction('MeasurementContract', 'AddMeasurement', ['7', '1', '-10'], gateway);
            
            const measurement = toObject<Measurement>(response);

            const expected = {
                sensorID: "1",
                value: "-10",
            } 

             expect(measurement).toMatchObject(expected);
        });
    });

    // describe('GetMeasurement', () => {
    //     it('should submit GetMeasurement transaction', async () => {
    //         const arg0: string = '1';
    //         const args: string[] = [arg0];
    //         const response: Buffer = await SmartContractUtil.submitTransaction('MeasurementContract', 'GetMeasurement', args, gateway);
            
    //         // submitTransaction returns buffer of transcation return value
    //         // TODO: Update with return value of transaction
    //         assert.strictEqual(true, true);
    //         // assert.strictEqual(JSON.parse(response.toString()), undefined);
    //     });
    // });

    // describe('GetHistory', () => {
    //     it('should submit GetHistory transaction', async () => {
    //         // TODO: populate transaction parameters
    //         const arg0: string = '1';
    //         const args: string[] = [arg0];
    //         const response: Buffer = await SmartContractUtil.submitTransaction('MeasurementContract', 'GetHistory', args, gateway);
            
    //         // submitTransaction returns buffer of transcation return value
    //         // TODO: Update with return value of transaction
    //         assert.strictEqual(true, true);
    //         // assert.strictEqual(JSON.parse(response.toString()), undefined);
    //     });
    // });

    // describe('ValidateSLA', () => {
    //     it('should submit ValidateSLA transaction', async () => {
    //         // TODO: populate transaction parameters
    //         const arg0: string = '1';
    //         const arg1: string = '-10';
    //         const args: string[] = [arg0, arg1];
    //         const response: Buffer = await SmartContractUtil.submitTransaction('MeasurementContract', 'ValidateSLA', args, gateway);
            
    //         // submitTransaction returns buffer of transcation return value
    //         // TODO: Update with return value of transaction
    //         assert.strictEqual(true, true);
    //         // assert.strictEqual(JSON.parse(response.toString()), undefined);
    //     });
    // });

});
