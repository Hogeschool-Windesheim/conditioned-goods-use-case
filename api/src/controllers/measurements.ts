import { Request, Response } from "express";
import { connect } from "../gateway";
import { toObject } from "../helpers";
import { Measurement, Shipment } from "../types";

/**
 * Get History
 */
export async function getHistory({ params }: Request, res: Response) {
    const { id } = params;
    const gateway = await connect();

    try {
        // Get channel
        const network = await gateway.getNetwork(process.env.CHANNELNAME);

        // Get contract
        const contract = network.getContract("basic", "MeasurementContract");

        // Query data
        const result = await contract.evaluateTransaction(
            "getHistory",
            `${id}`
        );

        res.json(toObject<Measurement>(result));
    } catch ({ message }) {
        res.status(500).json({ error: message });
    } finally {
        gateway.disconnect();
    }
}

/**
 * Get Measurement
 */
export async function getMeasurement({ params }: Request, res: Response) {
    const { id } = params;
    const gateway = await connect();

    try {
        // Get channel
        const network = await gateway.getNetwork(process.env.CHANNELNAME);

        // Get contract
        const contract = network.getContract("basic", "MeasurementContract");

        // Query data
        const result = await contract.evaluateTransaction(
            "getMeasurement",
            `${id}`
        );

        res.json(toObject<Measurement>(result));
    } catch ({ message }) {
        res.status(500).json({ error: message });
    } finally {
        gateway.disconnect();
    }
}

/**
 * Add Measurement
 */
export async function addMeasurement({ body }: Request, res: Response) {
    const { sensorID, value, timestamp } = body;
    const gateway = await connect();

    try {
        // Get channel
        const network = await gateway.getNetwork(process.env.CHANNELNAME);

        // Get contract
        const contract = network.getContract("basic", "MeasurementContract");

        // Query data
        const result = await contract.submitTransaction(
            "addMeasurement",
            `${sensorID}`,
            `${value}`,
            `${timestamp}`
        );

        res.json(toObject<Shipment>(result));
    } catch ({ message }) {
        res.status(500).json({ error: message });
    } finally {
        gateway.disconnect();
    }
}
