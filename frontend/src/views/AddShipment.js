/*eslint-disable*/
import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import useFetch, { Provider } from 'use-http'

import IndexNavbar from "components/Navbars/IndexNavbar.js";
import Shipment from "./admin/Shipment";
import { bottom } from "@popperjs/core";

export default function AddShipment() {
  const [shipmentId, setShipmentId] = useState('');
  const {post, Response, loading, error} = useFetch('http://localhost:8080/shipment/add')

  function changeShipmentId(e){
    setShipmentId(e.target.value)
    console.log({shipmentId});
  }

  async function PostShipment(e){
    e.preventDefault();
    console.log(JSON.stringify({id: shipmentId}));
    post({id: shipmentId}).then(() => console.log("TEST"))
  }

  return (
    <>
      <Provider options={{responseType:'json', headers:{Accept: 'application/json'}}}></Provider>
      <IndexNavbar fixed />
      <section className="container header pt-20 flex h-screen max-h-860-px">
        <div className="container">
            <div className="block text-3xl mb-2">Add Shipment: </div>
            <form onSubmit={PostShipment}>
                <div>
                    <p>Shipment:</p>
                    <label>
                    <input onChange={changeShipmentId} value={shipmentId} type="text" placeholder="shipment" className="border" />
                    </label>
                </div>
                
                <button type="submit">Add Shipment</button> 
            </form>
        </div>
      </section>
    </>
  );
}
