import {Request, Response} from "express";
import {Schema} from "express-validator";
import {getShipments, getShipment, shipmentExist, hasSensor, addShipment, registerSensor, updateShipment, getShipmentBySearchString} from './controllers/shipments';
import {shipmentAddSchema, getShipmentsSchema, getShipmentSchema, shipmentExistsSchema, hasSensorSchema, getShipmentBySearchStringSchema} from './schemas/shipmentschema';
import {getHistorySchema, getMeasurementSchema, addMeasurementSchema} from './schemas/measurementschema';
import {getHistory, getMeasurement, addMeasurement} from './controllers/measurements';

/**
 * API routes.
 */
export enum routes {
    SHIPMENTS = '/shipments/:amount?/:index?',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    HASSENSOR = '/shipment/:id/sensor/:sensorID',
    ADDSHIPMENT = '/shipment/add',
    REGISTERSENSOR = '/shipment/sensor/add',
    UPDATESHIPMENT = '/shipment/:id/update',
    GETHISTORY = '/shipment/:id/measurements',
    GETMEASUREMENT ='/shipment/:id/measurement',
    ADDMEASUREMENT = '/shipment/measurement/add',
    SEARCHSHIPMENT = '/shipments/search/:searchString?/:amount?/:index?',
}

/** 
 * Route type enum.
 */
export enum routeTypes {
    GET = 'get',
    POST = 'post',
}

type Route = {
    type: routeTypes,
    schema?: Schema,
    func: (req: Request, res: Response) => void,
}

/**
 * Resolve get routes.
 */
export const routeResolver: {[index: string]: Route} = {
    [routes.SEARCHSHIPMENT]: {type: routeTypes.GET, schema: getShipmentBySearchStringSchema, func: getShipmentBySearchString},
    [routes.SHIPMENTS]: {type: routeTypes.GET, schema: getShipmentsSchema, func: getShipments},
    [routes.SHIPMENT]: {type: routeTypes.GET, schema: getShipmentSchema, func: getShipment},
    [routes.SHIPMENTEXIST]: {type: routeTypes.GET, schema: shipmentExistsSchema, func: shipmentExist},
    [routes.HASSENSOR]: {type: routeTypes.GET, schema: hasSensorSchema, func: hasSensor},
    [routes.GETHISTORY]: {type: routeTypes.GET, schema: getHistorySchema, func: getHistory},
    [routes.GETMEASUREMENT]: {type: routeTypes.GET, schema: getMeasurementSchema, func: getMeasurement},
    [routes.ADDSHIPMENT]: {type: routeTypes.POST, schema: shipmentAddSchema, func: addShipment},
    [routes.REGISTERSENSOR]: {type: routeTypes.POST, schema: hasSensorSchema, func: registerSensor},
    [routes.UPDATESHIPMENT]: {type: routeTypes.POST, func: updateShipment},
    [routes.ADDMEASUREMENT]: {type: routeTypes.POST, schema: addMeasurementSchema, func: addMeasurement}
};