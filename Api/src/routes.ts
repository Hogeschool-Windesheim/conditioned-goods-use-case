import {getShipments, getShipment, shipmentExist, hasSensor, addShipment, registerSensor, updateShipment } from './controllers/shipments';
import {shipmentAddSchema, getShipmentSchema, shipmentExistsSchema, hasSensorSchema} from './schemas/shipmentschema';
import {getHistorySchema, getMeasurementSchema, addMeasurementSchema} from './schemas/measurementschema';
import {getHistory, getMeasurement, addMeasurement} from './controllers/measurements';

/**
 * API routes.
 */
export enum routes {
    SHIPMENTS = '/shipments',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    HASSENSOR = '/shipment/:id/sensor/:sensorID',
    ADDSHIPMENT = '/shipment/add',
    REGISTERSENSOR = '/shipment/sensor/add',
    UPDATESHIPMENT = '/shipment/:id/update',
    GETHISTORY = '/shipment/:id/measurements',
    GETMEASUREMENT ='/shipment/:id/measurement',
    ADDMEASUREMENT = '/shipment/measurement/add'
}

/**
 * Resolve get route functions.
 */
export const getResolver = {
    [routes.SHIPMENTS]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
    [routes.HASSENSOR]: hasSensor,
    [routes.GETHISTORY]: getHistory,
    [routes.GETMEASUREMENT]: getMeasurement,
}

/**
 * Resolve post route functions
 */
export const postResolver = {
    [routes.ADDSHIPMENT]: addShipment,
    [routes.REGISTERSENSOR]: registerSensor,
    [routes.UPDATESHIPMENT]: updateShipment,
    [routes.ADDMEASUREMENT]: addMeasurement
}

/**
 * Route schema validation
 */
// TODO: check typescript typing
export const routeSchemaValidation: {[key: string]: any} = {
    [routes.ADDSHIPMENT]: shipmentAddSchema,
    [routes.REGISTERSENSOR]: shipmentAddSchema,
    [routes.UPDATESHIPMENT]: shipmentAddSchema,
    [routes.SHIPMENT]: getShipmentSchema,
    [routes.SHIPMENTEXIST]: shipmentExistsSchema,
    [routes.HASSENSOR]: hasSensorSchema,
    [routes.GETHISTORY]: getHistorySchema,
    [routes.GETMEASUREMENT]: getMeasurementSchema,
    [routes.ADDMEASUREMENT]: addMeasurementSchema,
}