import {Context, Contract, Info, Transaction} from 'fabric-contract-api';
import Measurement from './models/Measurement';
import {toBytes} from './helpers';


/** 
 * SmartContract
 */
@Info({title: "Measurements", description: "measurements smart contract"})
export class SmartContract extends Contract {
    /** 
     * Setup of the ledger
     */
    @Transaction()
    public async InitLedger() {
        // nothing yet
    }

    /** 
     * Add data to ledger
     */
    @Transaction()
    public async AddData(ctx: Context, id: string, name: string, value: number) {
        // let mspid = ctx.clientIdentity.getMSPID();

        let measurement: Measurement = {
            name,
            value   
        }
        await ctx.stub.putState(id, toBytes(measurement));
    }

    /**
     * Retrieve data from the ledger
     */
    @Transaction(false)
    public async ReadData(ctx: Context, id: string) {
        const measurement = await ctx.stub.getState(id); 
        if (!measurement || measurement.length === 0) {
            throw new Error(`The asset ${id} does not exist`);
        }
        return measurement.toString();
    }
}