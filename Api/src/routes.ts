import {getShipments, getShipment, shipmentExist, hasSensor, addShipment, registerSensor, updateShipment } from './controllers/shipments';
import {shipmentAddSchema, getShipmentSchema, shipmentExistsSchema, hasSensorSchema, getShipmentsSchema} from './schemas/shipmentschema';

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
}

/**
 * Resolve get route functions.
 */
export const getResolver = {
    [routes.SHIPMENTS]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
    [routes.HASSENSOR]: hasSensor,
}

/**
 * Resolve post route functions
 */
export const postResolver = {
    [routes.ADDSHIPMENT]: addShipment,
    [routes.REGISTERSENSOR]: registerSensor,
    [routes.UPDATESHIPMENT]: updateShipment,
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
    [routes.SHIPMENTS ]:getShipmentsSchema,
}