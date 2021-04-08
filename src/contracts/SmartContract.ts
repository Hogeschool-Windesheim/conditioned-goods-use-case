import {Context, Contract} from 'fabric-contract-api';
import Measurement, {MeasurementType} from '../models/Measurement';
import {toBytes, toObject, toArrayOfObjects} from '../helpers';

// TODO: SLA Json file with requirements? Measurement Enum?
// TODO: Split this in to two contract (one for adding a shipment and one for adding the sensor data for in the shipment).
// TODO: Define Object structure.
/** 
 * SmartContract
 * Note: parameters of a function can not be an object.
 */
export class SmartContract extends Contract {
    /** 
     * Initial data for the ledger
     */
    public async InitLedger() {
        // nothing yet
    }

    /** 
     * Create data
     */
    public async AddData(ctx: Context, id: string, name: string, value: string) {
        // let mspid = ctx.clientIdentity.getMSPID();
        const exists = await this.DataExists(ctx, id);

        if (exists) {
            throw new Error('Data with this id does already exist.');
        }

        let measurement: Measurement = {
            type: MeasurementType.TEMP,
            value
        }

        // Submit data to the ledger.
        await ctx.stub.putState(id, toBytes<Measurement>(measurement));
    }

    /** 
     * Add data to ledger
     */
    public async UpdateData(ctx: Context, id: string, name: string, value: string) {
        const data = await this.ReadData(ctx, id);

        if (!data) {
            throw new Error('Data with this id does not exist.');
        }

        let measurement: Measurement = {
            ...data,
            value,
        }

        // Submit data to the ledger.
        await ctx.stub.putState(id, toBytes<Measurement>(measurement));
    }

    /** 
     * Checks if the id already exists on the ledger
     */
    public async DataExists(ctx: Context, id: string) {
        const data = await ctx.stub.getState(id);

        // Note: optional channing is not possible (probably because it is not complied right).
        return data && data.length > 0;
    }

    /** 
     * Retrieve all data from the ledger
     */
    public async ReadAllData(ctx: Context) {
        // Query all data in the ledger.
        const iterator = ctx.stub.getStateByRange('', '');

        return toArrayOfObjects<Measurement>(iterator);
    }

    /**
     * Retrieve data from the ledger
     */
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
    public async ReadHistory(ctx: Context, id: string) {
        // Query history from key
        const iterator = ctx.stub.getHistoryForKey(id);

        return toArrayOfObjects<Measurement>(iterator);
    }
}