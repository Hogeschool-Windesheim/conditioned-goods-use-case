import { Context, Contract } from "fabric-contract-api";
import Shipment from "../models/Shipment";
import Sensor from '../models/Sensor';
import { ESensorType } from '../models/ESensorType';;
import { toBytes, toObject, toJson, toArrayOfObjects } from "../libs/helpers";
import { ShipmentTransfer, EShipmentTransferState } from '../models/ShipmentTransfer';
import SLA from "../SLA.json";
import { isInRange } from "../libs/validate";
// Note: removed ts annotations because they currently do not allow nested objects.
/**
 * Handles the shipments in the ledger.
 */
export class ShipmentContract extends Contract {
    public async health(ctx: Context) {
        return 1
    }
    
    /**
     * Add a shipment to the ledger.
     */
    public async addShipment(ctx: Context, id: string, createdAt: number) {
 
        if(this.shipmentExist(ctx,id)){
            throw new Error("A shipment with this id already exist");
        }
        else{

        
        //the id for the owner should be his MSPID defined in the configtx.yml file 
            const shipment: Shipment = {
                id,
                sensors: [],
                createdAt,
                owner: ctx.clientIdentity.getMSPID(),
            }

            // Submit data to the ledger.
            await ctx.stub.putState(id, toBytes<Shipment>(shipment));
            return shipment;
        }
    }   

    //To create a Sensor and register it in the pool of sensor (in the database)

    public async createSensor(ctx: Context, id: string, category: ESensorType, createdAt: number) {
        
        if(this.sensorExist(ctx,id)){
            throw new Error("A sensor with this id already exist");
        }
        else {
            let sensor = new Sensor();
            //Same here to give an unique ID we use the current date 
            
            sensor.id = id;
            sensor.category = category;
            sensor.updatedAt = createdAt;
            //By default the sensor is not used and has no value  
            sensor.used = false;
            sensor.value = "";
            //push data in the ledger 
            await ctx.stub.putState(sensor.id, toBytes<Sensor>(sensor));
        }

    }

    //To get a sensor from the Ledger thanks to his ID 

    public async getSensor(ctx: Context, sensorID: string) {
        const sensor = await ctx.stub.getState(sensorID);
        if (!(sensor && sensor.length > 0)) {
            throw new Error(`Sensor with this id does not exist.`);
        }
        return sensor.toString();
    }

    public async sensorExist(ctx: Context, sensorID: string){
        const sensor=await ctx.stub.getState(sensorID);
        return(sensor && sensor.length>0);
    }
    
    /**
     * Get shipment from ledger.
     */
    public async getShipment(ctx: Context, id: string) {
        const shipment = await ctx.stub.getState(id);

        if (!(shipment && shipment.length > 0)) {
            throw new Error(`Shipment with this id does not exist.`);
        }

        return toObject<Shipment>(shipment);
    }

    /**
     * Check if shipment exist
     */
    public async shipmentExist(ctx: Context, id: string) {
        const shipment = await ctx.stub.getState(id);

        // Note: optional channing is not possible (probably because it is not complied right).
        return shipment && shipment.length > 0;
    }

    /**
     * Get all shipments from the ledger
     */
    /*
    public async getShipments(ctx: Context) {
        // Query all data in the ledger.
        const iterator = ctx.stub.getStateByRange("", "");

        return toArrayOfObjects<Shipment>(iterator);
    }
    */
    /**
     * Register sensor on a shipment
     */
    public async registerSensor(ctx: Context, id: string, sensorID: string) {
        //Get the shipment by the id 
        const shipment = await this.getShipment(ctx, id);
        let sensor = await this.getSensor(ctx, sensorID);


        /*
        if (shipment.sensors.id.includes(sensorID)) {
            throw new Error("Sensor is already registered to this shipment.")
        }*/

        //check if the shipment already have some sensors register 
        if (shipment.sensors.length > 0) {
            //if he has go through then and check if there is already a sensor of this type on it 
            for (let existingSensor of shipment.sensors) {
                if (existingSensor.category == sensor.category) {
                    throw new Error("There is already this type of sensor on this shipment");
                }
            }
        }
        //Check if the sensor is already used 
        if (sensor.used == false) {
            //Then add the sensor to the shipment 
            shipment.sensors.push(sensor);
            //Register the change in the blockchain 
            await ctx.stub.putState(id, toBytes<Shipment>(shipment));
        } else throw new Error("Sensor already used");


    }
    public async getReadings(ctx: Context, shipmentId: string) {
        const shipment = await this.getShipment(ctx, shipmentId);
        if (shipment.sensors.length > 0) {
            return shipment.sensors;
        }
        else {
            throw new Error("There is no sensor on this shipment");
        }
    }
    private async validateSLA(ctx: Context, sensors: Sensor[]) {

        let temperatureSensor: Sensor;
        //Going throught the array of sensors 
        for (let sensor of sensors) {
            //Trying to find if there is a temperature sensor 
            if (sensor.category == ESensorType.Temperature) {
                temperatureSensor = sensor;
            }
            else {
                //If there is not the shipment is not valid for a transaction
                return false;
            }
            //can add a if for every category of sensor(for exemple GPS)
        }

        const value = parseFloat(temperatureSensor.value);
        const minTemp = SLA.temperature.min;
        const maxTemp = SLA.temperature.max;

        //Check if the temperature is include between a minTemp and a maxTemp predefined 
        if (!isInRange(value, minTemp, maxTemp)) {
            // Temp value should always be an number.
            return false;
        }
        //If all the SLAs are validated the function return true
        return true;
    }
    public async getTransfer(ctx: Context, id: string) {
        const transfer = await ctx.stub.getState(id);

        if (!(transfer && transfer.length > 0)) {
            throw new Error(`Transfer with this id does not exist.`);
        }

        return toObject<ShipmentTransfer>(transfer);
    }
    /**
     * Function to handle the transfer of ownership to track every transaction 
     * @param ctx - context variable
     * @param id - id of the shipment
     * @param newOwner - Mspid of the new owner
    
     */
    public async transferOwnership(ctx: Context, id: string, newOwner: string): Promise<void> {
        let shipment = await this.getShipment(ctx, id);
        let actualOwner = shipment.owner;
        let shipmentTransfer: ShipmentTransfer;
        //check if you can invoke this function by checking if the MSPid is matched to the shipment
        if (actualOwner == ctx.clientIdentity.getMSPID()) {
            shipmentTransfer.fromOwner = actualOwner;
            shipmentTransfer.toOwner = newOwner;
            shipmentTransfer.shipmentId = "transfer" + id;
            //check if the conditions to start the transfer are correct
            if (await this.validateSLA(ctx, shipment.sensors)) {
                shipmentTransfer.state = EShipmentTransferState.Pending;
                await ctx.stub.putState(shipmentTransfer.shipmentId, toBytes<ShipmentTransfer>(shipmentTransfer));

            }
            else {
                shipmentTransfer.state = EShipmentTransferState.Cancelled;
                await ctx.stub.putState(shipmentTransfer.shipmentId, toBytes<ShipmentTransfer>(shipmentTransfer));


            }
        }

    }
    /**
     * function that need to be invoke to accept an ownership, if it is invoke it changes the state of the transfer
     * @param ctx - context
     * @param id - id of the shipment
     * @returns - boolean if the transfer is succesful or not
     */
    public async acceptOwnership(ctx: Context, id: string): Promise<boolean> {
        let shipment = await this.getShipment(ctx, id);
        let shipmentTransfer = await this.getTransfer(ctx, "transfer" + id);
        //check if the state of the shipement is right
        if (shipmentTransfer.state == EShipmentTransferState.Pending) {
            //check if you can invoke this function by checking if the MSPid is matched to the transfer
            if (ctx.clientIdentity.getMSPID() == shipmentTransfer.toOwner) {
                //changes the owner and the state of the transfer and submit it to the ledger
                shipmentTransfer.state = EShipmentTransferState.Completed;
                shipment.owner = shipmentTransfer.toOwner;
                await ctx.stub.putState(id, toBytes<Shipment>(shipment));
                await ctx.stub.putState(shipmentTransfer.shipmentId, toBytes<ShipmentTransfer>(shipmentTransfer));
                return true;
            }
            else {
                //changes the state of the transfer and submit it to the ledger
                shipmentTransfer.state = EShipmentTransferState.Cancelled;
                await ctx.stub.putState(id, toBytes<ShipmentTransfer>(shipmentTransfer));
                throw new Error("You cannot this transfer");
                return false;
            }
            /**
             * Check if sensor is registered in a shipment.
             */
            /*
            public async sensorIsRegistered(
                ctx: Context,
                id: string,
                sensorID: string
            ) {
                const shipment = await this.getShipment(ctx, id);
        
                return shipment.sensors.includes(sensorID);
            }
            */
            /**
             * Get shipments by sensorID.
             */
            /*
            public async getShipmentBySensor(ctx: Context, id: string) {
                const query = {
                    selector: {
                        sensors: {
                            $elemMatch: {
                                $eq: id,
                            },
                        },
                    },
                };
        
                const iterator = ctx.stub.getQueryResult(toJson(query));
                const shipments = await toArrayOfObjects<Shipment>(iterator);
        
                if (!(shipments && shipments.length > 0)) {
                    throw new Error("Sensor is not registered to a shipment");
                }
        
                return shipments[0];
            }*/
        }
    }
}
