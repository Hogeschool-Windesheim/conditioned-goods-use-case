import { Context, Contract } from "fabric-contract-api";
import Sensor from "../models/Sensor";
import Shipment from "../models/Shipment";
import { ShipmentContract } from "./ShipmentContract";
import { toBytes, toObject, toArrayOfObjects } from "../libs/helpers";
import SLA from "../SLA.json";
import { isInRange } from "../libs/validate";
import { sendMail } from "../libs/mail";
import { getHtml, getText } from "../mails/temperature";
import { ESensorType } from "../models/ESensorType";


/**
 * Handles the measurements and sensors in the shipments.
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
     * Should we still use this one ? 
     */
    /*
    public async getMeasurement(ctx: Context, id: string) {
        const shipment: Shipment = await this.shipmentContract.getShipment(
            ctx,
            id
        );
        return shipment.temperature;
    }
    */



    /**
     * Get measurement history
     */
    /*
    public async getHistory(ctx: Context, id: string) {
        const iterator = ctx.stub.getHistoryForKey(id);
        const shipments = await toArrayOfObjects<Shipment>(iterator);

        // Map through the shipment history and get the temperature values.
        return shipments
            .filter(({ temperature }) => temperature)
            .map(({ temperature }) => temperature);
    }
    */

    /**
     * Add a measurement to a shipment.
     * NOTE: timestamp is the amount of milliseconds since 1970 (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date#the_ecmascript_epoch_and_timestamps)
     */
    public async addMeasurement(ctx: Context, sensorID: string, value: string, timestamp: string) {
        let shipment: Shipment = await this.shipmentContract.getShipmentBySensor(ctx, sensorID);
        let date = parseInt(timestamp);
        //To check if we found the sensor on this shipment 
        let sensorFound: boolean = false;
        /*
        if (!(await this.validateSLA(ctx, shipment.id, temperature))) {
            await sendMail(
                `Shipment #${shipment.id}`,
                getText(shipment.id, value),
                getHtml(shipment.id, value)
            );
        }
        */
        //Go throught all the sensors of the shipment 
        for (let sensor of shipment.sensors) {
            //If we found one that have the matching ID we update his value and the last uptdatedAt at now and we register this changes in the database
            if (sensor.id == sensorID) {
                sensor.value = value;
                sensor.updatedAt = date;//Could also be Date.now() ?
                await ctx.stub.putState(sensorID, toBytes<Sensor>(sensor));
                await ctx.stub.putState(shipment.id, toBytes<Shipment>(shipment));
                sensorFound = true;
            }
        }
        //If we didn't find the sensor throw an error
        if (!sensorFound) throw new Error("Sensor with this ID not found");
    }

    /**
     * Validate SLA used to validate the SLAs which for now are just that the temperature is include between a maximum and a minimum
     */

}
