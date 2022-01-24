export enum EShipmentTransferState {
    Pending = "PENDING",
    Cancelled = "CANCELLED",
    Completed = "COMPLETED"
}

export type ShipmentTransfer = {
    /**
     * MSPID from who made the transfer request
     */
    fromOwner: string,//from who the transfer should be send to

    toOwner: string,
    /**
     * The identifier of the shipment in question
     */
    shipmentId: string,
    /**
     * MSPID fr
     * The state of the transfer request
     */
    state: EShipmentTransferState

}