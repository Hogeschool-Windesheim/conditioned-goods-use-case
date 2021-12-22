import express, { Request, Response } from "express";
import { validationResult } from "express-validator";
import cors from "cors";
import helmet from "helmet";
import compression from "compression";
import dotenv from "dotenv";
import { checkSchema } from "express-validator";
import { routeTypes, routeResolver } from "./routes";
import { connect } from "./gateway";

// Register .env file.
dotenv.config();

// New instance of express.
export const app = express();

// Parse request to json.
app.use(express.json());
app.use(compression());
app.use(helmet());
app.use(
    cors({
        origin: "http://localhost:3001",
    })
);

app.post("/soft/:contract", async (req: Request, res: Response) => {
    const [contractName, funcName] = req.params.contract!.split(".");
    const gateway = await connect();
    console.log({contractName, funcName});
    try {
        // Get channel
        const network = await gateway.getNetwork(process.env.CHANNELNAME);

        // Get contract
        const contractMap = new Map<string, any>([]);
        contractMap.set('shipment', network.getContract("nice", "ShipmentContract"));
        contractMap.set('measurement', network.getContract("nice", "MeasurementContract"));

        const isInvocation = !!req.query["invoke"] || false;
        console.log({isInvocation});
        
        const usedContract = contractMap.get(contractName)!;
        console.log({usedContract})

        let contractArgs;
        if (Array.isArray(req.body) === false) {
            contractArgs = [];
        } else {
            contractArgs = req.body
        }

        console.log({contractArgs})
        const result: Buffer = await usedContract.submitTransaction(funcName, ...req.body);
        console.log([result.length, result.toString()])
        res.write(result);
    } catch (err) {
        res.status(500).write(err.toString());
    }
    // finally {
    //     gateway.disconnect();
    // }
});



// Loop through all the routes
// for (const [key, value] of Object.entries(routeResolver)) {
//     const { type, schema = {}, func } = value;

//     // Get the function assosiated with the type of the request from the app object.
//     // And register the assosiated route, shema and function in express.
//     app[type](key, checkSchema(schema), (req: Request, res: Response) => {
//         // Validate schema.
//         const errors = validationResult(req);

//         // Check if validation returned errors, if it has return them with an error code.
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 errors: errors.array(),
//             });
//         }

//         // call the assosiated route function.
//         func(req, res);
//     });
// }
