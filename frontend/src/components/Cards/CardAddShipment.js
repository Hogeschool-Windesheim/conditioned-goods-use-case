/*eslint-disable*/
import React, { useEffect, useState } from "react";
import useFetch, { Provider } from 'use-http'


export default function CardAddShipment() {
    const [shipmentId, setShipmentId] = useState('');
    const {post, Response, loading, error} = useFetch('http://localhost:8080/shipment/add')

    function changeShipmentId(e){
        setShipmentId(e.target.value);
        console.log({shipmentId});
    }

    async function PostShipment(e){
        e.preventDefault();
        post({id: shipmentId}).then(window.location.href = "http://localhost:3000/admin/dashboard");
    }

  return (
    <div className="relative flex flex-col break-words bg-white mb-6 shadow-lg rounded">
        <div className="rounded-t px-4 py-3">
          <h2 className="text-blueGray-700 text-xl font-semibold">
            Add Shipment
          </h2>
        </div>
      
        <div className="p-4">
            <form onSubmit={PostShipment}>
                <div className="py-2">
                    <p className="font-medium">Shipment ID:</p>
                    <label>
                    <input onChange={changeShipmentId} value={shipmentId} type="text" placeholder="shipment" className="border" />
                    </label>
                </div>

                <div className="py-2">
                    <button type="submit" className="bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded">Add Shipment</button>
                </div>
            </form>
        </div>
    </div>
  );
}