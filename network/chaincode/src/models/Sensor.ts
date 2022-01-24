
import { Object, Property } from 'fabric-contract-api';
import { ESensorType } from './ESensorType';
/** 
 * Measurement
 */


export default class Sensor {
    public id: string;
    public category: ESensorType;
    public value: string;
    public updatedAt: number;
    public used: boolean;
}