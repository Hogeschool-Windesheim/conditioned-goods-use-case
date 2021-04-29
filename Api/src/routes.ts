import {getShipments, getShipment, shipmentExist, addShipment} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
    ADDSHIPMENT = '/shipment/:id/add',
}

/**
 * Resolve route functions.
 */
export const routeResolver = {
    [routes.BASE]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
    [routes.ADDSHIPMENT]: addShipment,
}