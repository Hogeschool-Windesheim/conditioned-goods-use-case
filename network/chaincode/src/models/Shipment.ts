import { Object, Property } from "fabric-contract-api";
import Measurement from "./Sensor";
import Sensor from './Sensor';
/**
 * Shipment
 */
export default class Shipment {
    public id: string;
    public sensors: Array<Sensor>;
    public createdAt: number;
    public owner: string;
}