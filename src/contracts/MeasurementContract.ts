import {Context, Contract} from 'fabric-contract-api';
import Measurement from '../models/Measurement';
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

        // Make an instance of the ShipmentContract to make the methods inside available.
        this.shipmentContract = new ShipmentContract();
    }


    /** 
     * Get a measurement from a shipment.
     */
    public async GetMeasurement(ctx: Context, id: string) {
        const shipment: Shipment = await this.shipmentContract.GetShipment(ctx, id);
        return shipment.temperature;
    }

    /** 
     * Get measurement history
     */
    public async GetHistory(ctx: Context, id: string) {
        const iterator = ctx.stub.getHistoryForKey(id);
        const shipments = await toArrayOfObjects<Shipment>(iterator);

        // Map through the shipment history and get the temperature values.
        return shipments.filter(({temperature}) => temperature).map(({temperature}) => temperature);;
    }

    /** 
     * Add a measurement to a shipment.
     */
    public async AddMeasurement(ctx: Context, id: string, sensorID: string, value: string) {
        let shipment: Shipment = await this.shipmentContract.GetShipment(ctx, id);

        if (!await this.shipmentContract.HasSensor(ctx, id, sensorID)) {
            throw new Error(`Sensor is not registered to this shipment.`);
        }

        if (!await this.ValidateSLA(ctx, id, parseInt(value))) {
            // TODO: send message
        }

        shipment.temperature = {
            value,
            sensorID
        }

        await ctx.stub.putState(id, toBytes<Shipment>(shipment));
    }

    /** 
     * Validate SLA
     */
    private async ValidateSLA(ctx: Context, id: string, newValue: number) {
        const temp = await this.GetMeasurement(ctx, id);
        
        if (newValue < -20 || newValue > 20) {
            if (!temp || temp && temp.value > -20 && temp.value < 20) {
                return false;
            }
        }

        return true;
    }
}