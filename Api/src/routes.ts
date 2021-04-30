import {getShipments, getShipment, shipmentExist, addShipment, registerSensor, hasSensor} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    ADDSHIPMENT = '/shipment/add',
    REGISTERSENSOR = '/shipment/sensor/add',
    UPDATESHIPMENT = '/shipment/:id/update',
    HASSENSOR = '/shipment/:id/:sensorID/hassensor',
}

/**
 * Resolve get route functions.
 */
export const getResolver = {
    [routes.BASE]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
    [routes.ADDSHIPMENT]: addShipment,
    [routes.HASSENSOR]: hasSensor,
    [routes.REGISTERSENSOR]: registerSensor,
}
