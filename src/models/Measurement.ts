
import {Object, Property} from 'fabric-contract-api';

export enum MeasurementType {
    TEMP = "temperature"
}

// TODO: maybe add a sensorID, to know which sensor send the data.
/** 
 * Measurement
 */
export default class Measurement {
    public type: MeasurementType;
    public value: string | number;
}