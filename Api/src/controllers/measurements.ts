import {Request, Response} from "express";
import {connect} from '../gateway';
import {toObject} from '../helpers';
import {Measurement} from '../types';

/**
 * Get measurement from shipment
 */
 export async function getMeasurement({params}: Request, res: Response) {
    console.log(params); 
    const {id} = params;
    console.log(id);
    const gateway = await connect();

    try {
      // Get channel
      const network = await gateway.getNetwork('mychannel');

      // Get contract
      const contract = network.getContract('blockchain-backend');

      // Query data
      const result = await contract.evaluateTransaction('GetHistory',`${id}`);

      res.json(toObject<Measurement>(result));
    } catch(err) {
      // TODO: An error logger like sentry would be nice.
      console.log(err);
    } finally {
      gateway.disconnect();
    }
}