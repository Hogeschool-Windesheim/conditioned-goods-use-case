import {getShipments, getShipment} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
    SHIPMENT = '/shipment/:id',
}

/**
 * Resolve route functions.
 */
export const routeResolver = {
    [routes.BASE]: getShipments, 
    [routes.SHIPMENT]: getShipment,
}