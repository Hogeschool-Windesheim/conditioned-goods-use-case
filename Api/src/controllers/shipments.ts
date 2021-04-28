import {Request, Response} from "express";
import {connect} from '../gateway';

export async function getShipments(req: Request, res: Response) {
    const gateway = await connect();

    try {
      // Get channel
      const network = await gateway.getNetwork('mychannel');

      // Get contract
      const contract = network.getContract('blockchain-backend');

      // Query data
      const result = await contract.evaluateTransaction('GetShipments');

      res.json(JSON.parse(result.toString()));
    } catch(err) {
      // TODO: An error logger like sentry would be nice.
      // tslint:disable-next-line:no-console
      console.log(err);
    } finally {
      gateway.disconnect();
    }
}