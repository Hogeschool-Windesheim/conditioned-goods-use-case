import path from "path";
import { buildCCPOrg1, buildWallet } from "../utils/AppUtil";
import { buildCAClient, enrollAdmin, registerAndEnrollUser } from "../utils/CAUtil";

const mspOrg1 = "Org1MSP";
const walletPath = path.join(__dirname, "wallet");
const org1UserId = "appUser";

async function main() {
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
}

main();