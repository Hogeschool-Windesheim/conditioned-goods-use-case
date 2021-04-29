import {getShipments, getShipment, shipmentExist} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
    SHIPMENT = '/shipment/:id',
    SHIPMENTEXIST = '/shipment/:id/exist',
}

/**
 * Resolve route functions.
 */
export const routeResolver = {
    [routes.BASE]: getShipments, 
    [routes.SHIPMENT]: getShipment,
    [routes.SHIPMENTEXIST]: shipmentExist,
}