import { Gateway, GatewayOptions, Wallets } from "fabric-network";
import * as path from "path";
// TODO: make import of connection profile by path instead of import
import org1 from "../profiles/connection-org1.json";
import { buildCCPOrg1, buildWallet } from "../utils/AppUtil";
import {
    buildCAClient,
    enrollAdmin,
    registerAndEnrollUser,
} from "../utils/CAUtil";

const mspOrg1 = "Org1MSP";
const walletPath = path.join(__dirname, "wallet");
const org1UserId = "appUser";
/**
 * Setup a gateway conenction to the HLF Network.
 */
export async function connect(): Promise<Gateway> {
    const ccp = buildCCPOrg1();
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    // Create a new gateway instance for interacting with the fabric network.
    // In a real application this would be done as the backend server session is setup for
    // a user that has been verified.
    const gateway = new Gateway();

    const gatewayOpts: GatewayOptions = {
        wallet,
        identity: org1UserId,
        discovery: { enabled: true, asLocalhost: true }, // using asLocalhost as this gateway is using a fabric network deployed locally
    };

    // setup the gateway instance
    // The user will now be able to create connections to the fabric network and be able to
    // submit transactions and query. All transactions submitted by this gateway will be
    // signed by this user using the credentials stored in the wallet.
    await gateway.connect(ccp, gatewayOpts);
    return gateway;
}
