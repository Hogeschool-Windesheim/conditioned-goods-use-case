import {Context, Contract, Info, Transaction} from 'fabric-contract-api';
import Measurement from './models/Measurement';
import {toBytes, toObject, toArrayOfObjects} from './helpers';

// TODO: Split this in to two contract (one for adding a shipment and one for adding the sensor data for in the shipment).
// TODO: Define Object structure.
/** 
 * SmartContract
 */
@Info({title: "Measurements", description: "measurements smart contract"})
export class SmartContract extends Contract {
    /** 
     * Initial data for the ledger
     */
    @Transaction()
    public async InitLedger() {
        // nothing yet
    }

    /** 
     * Create data
     */
    @Transaction()
    public async AddData(ctx: Context, id: string, name: string, value: string) {
        // let mspid = ctx.clientIdentity.getMSPID();
        const exists = await this.DataExists(ctx, id);

        if (exists) {
            throw new Error('Data with this id does already exist.');
        }

        let measurement: Measurement = {
            id,
            name,
            value
        }

        await ctx.stub.putState(id, toBytes<Measurement>(measurement));
    }

    /** 
     * Add data to ledger
     */
    @Transaction()
    public async UpdateData(ctx: Context, id: string, name: string, value: string) {
        const data = await this.ReadData(ctx, id);

        if (!data) {
            throw new Error('Data with this id does not exist.');
        }

        let measurement: Measurement = {
            ...data,
            name,
            value 
        }

        await ctx.stub.putState(id, toBytes<Measurement>(measurement));
    }

    /** 
     * Checks if the id already exists on the ledger
     */
    @Transaction(false)
    public async DataExists(ctx: Context, id: string) {
        const data = await ctx.stub.getState(id);

        // Note: optional channing is not possible (probably because it is not complied right).
        return data && data.length > 0;
    }

    /** 
     * Retrieve all data from the ledger
     */
    @Transaction(false)
    public async ReadAllData(ctx: Context) {
        // Query all data in the ledger.
        const iterator = ctx.stub.getStateByRange('', '');
        return toArrayOfObjects<Measurement>(iterator);
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

        return toObject<Measurement>(measurement);
    }

    /** 
     * Retrieve history of a key from the ledger.
     */
    @Transaction(false)
    public async ReadHistory(ctx: Context, id: string) {
        // Query history from key
        const iterator = ctx.stub.getHistoryForKey(id);
        return toArrayOfObjects<Measurement>(iterator);
    }
}