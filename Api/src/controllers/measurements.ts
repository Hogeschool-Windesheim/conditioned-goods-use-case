import {Request, Response} from "express";
import {connect} from '../gateway';
import {toObject} from '../helpers';
import {Measurement} from '../types';

/**
 * Get measurement from shipment
 */
 export async function getMeasurements({body}: Request, res: Response) {
    console.log(body); 
    const {id} = body;
    console.log(id);
    const gateway = await connect();

    try {
      // Get channel
      const network = await gateway.getNetwork('mychannel');

      // Get contract
      const contract = network.getContract('blockchain-backend');

      // Query data
      const result = await contract.evaluateTransaction('GetMeasurement',`${id}`);

      res.json(toObject<Measurement>(result));
    } catch(err) {
      // TODO: An error logger like sentry would be nice.
      console.log(err);
    } finally {
      gateway.disconnect();
    }
}