import {Context, Contract} from 'fabric-contract-api';
import Shipment from '../models/Shipment';
import {toBytes, toObject, toArrayOfObjects} from '../helpers';

// Note: removed ts annotations because they currently do not allow nested objects.
/** 
 * Handles the shipments in the ledger. 
 */
export class ShipmentContract extends Contract {
    /** 
     * Add a shipment to the ledger.
     */
    public async AddShipment(ctx: Context, id: string) {

        if (!this.ShipmentExist(ctx, id)) {
            throw new Error("Shipment with this id does not exist.");
        }

        let shipment: Shipment = {
            id,
            sensors: [],
        }

        // Submit data to the ledger.
        await ctx.stub.putState(id, toBytes<Shipment>(shipment));

        return shipment;
    }

    // TODO: extends this methode when we know more about the content of a shipment.
    /** 
     * Update shipment in the ledger.
     */
    public async UpdateShipment(ctx: Context, id: string) {
        const shipment = await this.GetShipment(ctx, id);

        if (!shipment) {
            throw new Error('Shipment with this id does not exist.');
        }

        // TODO: set values we want to change.

        await ctx.stub.putState(id, toBytes<Shipment>(shipment));

        return shipment;
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
     * Check if shipment exist
     */
    public async ShipmentExist(ctx: Context, id: string) {
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

    /** 
     * Register sensor on a shipment
     */
    public async RegisterSensor(ctx: Context, id: string, sensorID: string) {
        const shipment = await this.GetShipment(ctx, id);

        if (!shipment.sensors.includes(sensorID)) {
            shipment.sensors = [...shipment.sensors, sensorID];

            await ctx.stub.putState(id, toBytes<Shipment>(shipment));

            return true;
        }

        return false;
    }

    /** 
     * Check if sensor is registered in a shipment.
     */
    public async HasSensor(ctx: Context, id: string, sensorID: string) {
        const shipment = await this.GetShipment(ctx, id);

        return shipment.sensors.includes(sensorID);
    }
}