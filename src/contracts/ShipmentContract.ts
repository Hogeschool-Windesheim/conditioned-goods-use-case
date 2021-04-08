import {Context, Contract} from 'fabric-contract-api';
import Shipment from '../models/Shipment';
import {MeasurementType} from '../models/Measurement';
import {toBytes, toObject, toArrayOfObjects} from '../helpers';

// Note: removed ts annotations because they currently do not allow nested objects.
/** 
 * Handles the shipments in the ledger. 
 */
export class ShipmentContract extends Contract {
    /** 
     * Add a shipment to the ledger.
     */
    public async AddShipment(ctx: Context) {
        let shipment: Shipment = {
            id: '0',
            temperature: {
                type: MeasurementType.TEMP,
                value: 0,
            }
        }

         // Submit data to the ledger.
        await ctx.stub.putState('0', toBytes<Shipment>(shipment));
    }

    /** 
     * Get shipment from ledger. 
     */
    public async GetShipment(ctx: Context, id: string) {
        const shipment = await ctx.stub.getState(id); 

        if (!shipment || shipment.length === 0) {
            throw new Error(`Shipment does not exist.`);
        }

        return toObject<Shipment>(shipment);
    }

    /** 
     * Check if shipment exists
     */
    public async ShipmentExists(ctx: Context, id: string) {
        const shipment = await ctx.stub.getState(id);

        // Note: optional channing is not possible (probably because it is not complied right).
        return shipment && shipment.length > 0;
    }

    /** 
     * Get all shipments from the ledger
     */
    public async GetShipments(ctx: Context) {
        // Query all data in the ledger.
        const iterator = ctx.stub.getStateByRange('', '');

        return toArrayOfObjects<Shipment>(iterator);
    }
}