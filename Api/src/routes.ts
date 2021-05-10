import {getShipments, getShipment, shipmentExist, hasSensor, addShipment, registerSensor, updateShipment } from './controllers/shipments';
import {getMeasurement} from './controllers/measurements';

/**
 * API routes.
 */
export enum routes {
    SCHIPMENTS = '/shipments',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    HASSENSOR = '/shipment/:id/:sensorID/hassensor',
    ADDSHIPMENT = '/shipment/add',
    REGISTERSENSOR = '/shipment/sensor/add',
    UPDATESHIPMENT = '/shipment/:id/update',

    MEASUREMENT = '/measurement/:id',
}

/**
 * Resolve get route functions.
 */
export const getResolver = {
    [routes.SCHIPMENTS]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
    [routes.HASSENSOR]: hasSensor,

    [routes.MEASUREMENT]: getMeasurement,
}

/**
 * Resolve post route functions
 */
export const postResolver = {
    [routes.ADDSHIPMENT]: addShipment,
    [routes.REGISTERSENSOR]: registerSensor,
    [routes.UPDATESHIPMENT]: updateShipment,
}