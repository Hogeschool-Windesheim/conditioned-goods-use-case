import {createTransport} from 'nodemailer';
import {Context, Contract} from 'fabric-contract-api';
import Measurement from '../models/Measurement';
import Shipment from '../models/Shipment';
import {ShipmentContract} from './ShipmentContract';
import {toBytes, toObject, toArrayOfObjects} from '../helpers';
import SLA from '../SLA.json';
import {isInRange} from '../validate';

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

        if (!shipment.sensors.includes(sensorID)) {
            throw new Error(`Sensor is not registered to this shipment.`);
        }

        if (!await this.ValidateSLA(ctx, id, parseInt(value))) {
            const transport = createTransport({
                host: process.env.MAIL_HOST,
                port: process.env.MAIL_PORT,
                auth: {
                    user: process.env.MAIL_USER,
                    pass: process.env.MAIL_PASSWORD
                }
            });

            await transport.sendMail({
                from: process.env.MAIL_ADDRESS,
                // TODO: remvome , from splitted array ':)
                to:  process.env.MAIL_RECIEVERS.split(","), 
                subject: process.env.MAIL_SUBJECT,
                text: "HELLO THERE", 
                html: "<b>GENERAL KENOBI</b>",
            });
        }

        const temperature = {
            value,
            sensorID,
            timestamp: new Date(),
        }

        shipment.temperature = temperature;

        await ctx.stub.putState(id, toBytes<Shipment>(shipment));

        return temperature;
    }

    /** 
     * Validate SLA
     */
    private async ValidateSLA(ctx: Context, id: string, newValue: number) {
        const temp = await this.GetMeasurement(ctx, id);
        const minTemp = SLA.temperature.min;
        const maxTemp = SLA.temperature.max;
        
        if (!isInRange(newValue, minTemp, maxTemp)) {
            // Temp value should always be an number.
            if (!temp || temp && !isInRange(temp.value as number, minTemp, maxTemp)) {
                return false;
            }
        }

        return true;
    }
}