import {Request, Response} from "express";
import {connect} from '../gateway';
import {toObject} from '../helpers';
import {Shipment} from '../types';

/**
 * Get shipments.
 */
export async function getShipments(req: Request, res: Response) {
    const gateway = await connect();

    try {
      // Get channel
      const network = await gateway.getNetwork('mychannel');

      // Get contract
      const contract = network.getContract('blockchain-backend');

      // Query data
      const result = await contract.evaluateTransaction('GetShipments');

      res.json(toObject<Shipment>(result));
    } catch(err) {
      // TODO: An error logger like sentry would be nice.
      console.log(err);
    } finally {
      gateway.disconnect();
    }
}

/**
 * Get shipment.
 */
 export async function getShipment({params}: Request, res: Response) {
  const {id} = params;
  const gateway = await connect();

  try {
    // Get channel
    const network = await gateway.getNetwork('mychannel');

    // Get contract
    const contract = network.getContract('blockchain-backend');

    // Query data
    const result = await contract.evaluateTransaction('GetShipment', `${id}`);

    res.json(toObject<Shipment>(result));
  } catch(err) {
    console.log(err);
  } finally {
    gateway.disconnect();
  }
}


/**
 * Checks if shipment exists
 */
 export async function shipmentExist({params}: Request, res: Response) {
  const {id} = params;
  const gateway = await connect();

  try {
    // Get channel
    const network = await gateway.getNetwork('mychannel');

    // Get contract
    const contract = network.getContract('blockchain-backend');

    // Query data
    const result = await contract.evaluateTransaction('ShipmentExists', `${id}`);

    res.json(toObject<boolean>(result));
  } catch(err) {
    console.log(err);
  } finally {
    gateway.disconnect();
  }
}