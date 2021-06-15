
import React from "react";
import useAddShipment from './containerHook';

/** 
 * Add shipment page.
 */
export default function AddShipment() {
  const {form, createShipment, onChange} = useAddShipment();

  return (
    <div className="w-full px-4">
       <div className="relative flex flex-col break-words bg-white mb-6 shadow-lg rounded">
          <div className="rounded-t px-4 py-3">
            <h2 className="text-blueGray-700 text-xl font-semibold">
              Add Shipment
            </h2>
          </div>
          <div className="p-4">
              <form onSubmit={createShipment}>
                  <div className="py-2">
                      <p className="font-medium mb-2">Shipment ID:</p>
                      <input value={form.id} name="id" onChange={onChange} type="text" placeholder="shipment ID" className="form-input border rounded" />
                  </div>
                  <div className="py-2">
                      <button type="submit" className="bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded">
                          Add Shipment
                      </button>
                  </div>
              </form>
          </div>
      </div>
    </div>
  );
}
