import {Contract, Context} from 'fabric-contract-api';
import Measurement from './models/Measurement';
import {toBytes} from './helpers';

type Object = {
    name: string;
    value: number;
    owner: any;
}

/** 
 * SmartContract
 */
export default class SmartContract extends Contract {

    /** 
     * Contructor
     */
    constructor() {
        super('org.condgood.smartcontract');
    }

    /** 
     * Setup of the ledger
     */
    async instantiate() {
        // nothing yet
    }

    /** 
     * Add data to ledger
     */
    async addData(ctx: Context, object: Object) {
        // let mspid = ctx.clientIdentity.getMSPID();

        let measurement = new Measurement("test", 1, "test");
        await ctx.stub.putState("test", toBytes(measurement));
    }
}