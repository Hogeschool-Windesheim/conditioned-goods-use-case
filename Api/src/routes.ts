import {getShipments, getShipment, shipmentExist, addShipment, registerSensor} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    ADDSHIPMENT = '/shipment/add',
    REGISTERSENSOR = '/shipment/sensor/add',
}

/**
 * Resolve get route functions.
 */
export const getResolver = {
    [routes.BASE]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
}

/**
 * Resolve post route functions
 */
export const postResolver = {
    [routes.ADDSHIPMENT]: addShipment,
    [routes.REGISTERSENSOR]: registerSensor,
}