import {Context, Contract} from 'fabric-contract-api';
import Measurement, {MeasurementType} from '../models/Measurement';
import Shipment from '../models/Shipment';
import {ShipmentContract} from './ShipmentContract';
import {toBytes, toObject, toArrayOfObjects} from '../helpers';

// Note: removed ts annotations because they currently do not allow nested objects.
/** 
 * Handles the measurements in the shipments. 
 */
export class MeasurementContract extends Contract {
    private shipmentContract: ShipmentContract;

    /** 
     * Constructor
     */
    constructor() {
        super();

        this.shipmentContract = new ShipmentContract();
    }


    /** 
     * Get a measurement from a shipment.
     */
    public async GetMeasurement(ctx: Context, id: string) {
        let shipment: Shipment = await this.shipmentContract.GetShipment(ctx, id);

        return shipment.temperature;
    }

    /** 
     * Add a measurement to a shipment
     */
    public async AddShipment(ctx: Context, id: string, type: MeasurementType, value: string) {
        let shipment: Shipment = await this.shipmentContract.GetShipment(ctx, id);

        shipment.temperature = {
            type,
            value,
        }

        await ctx.stub.putState(id, toBytes<Shipment>(shipment));
    }

}