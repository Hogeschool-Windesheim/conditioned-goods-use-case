import {Context, Contract, Info, Transaction} from 'fabric-contract-api';
import Measurement from './models/Measurement';
import {toBytes} from './helpers';


/** 
 * SmartContract
 */
 @Info({title: "Measurements", description: "measurements smart contract"})
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
    @Transaction()
    public async instantiate() {
        // nothing yet
    }

    /** 
     * Add data to ledger
     */
    @Transaction()
    public async addData(ctx: Context, id: number, name: string, value: number) {
        // let mspid = ctx.clientIdentity.getMSPID();

        let measurement: Measurement = {
            name,
            value   
        }
        await ctx.stub.putState(id, toBytes(measurement));
    }
}