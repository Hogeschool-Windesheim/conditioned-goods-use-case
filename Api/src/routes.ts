import {getShipments} from './controllers/shipments';

/**
 * API routes.
 */
export enum routes {
    BASE = '/',
}

/**
 * Resolve route functions.
 */
export const routeResolver = {
    [routes.BASE]: getShipments
}