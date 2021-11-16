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
    // build an in memory object with the network configuration (also known as a connection profile)
    const ccp = buildCCPOrg1();

    // build an instance of the fabric ca services client based on
    // the information in the network configuration
    const caClient = buildCAClient(ccp, "ca.org1.example.com");

    // setup the wallet to hold the credentials of the application user
    const wallet = await buildWallet(walletPath);

    // // in a real application this would be done on an administrative flow, and only once
    await enrollAdmin(caClient, wallet, mspOrg1);

    // in a real application this would be done only when a new user was required to be added
    // and would be part of an administrative flow
    await registerAndEnrollUser(
        caClient,
        wallet,
        mspOrg1,
        org1UserId,
        "org1.department1"
    );

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
