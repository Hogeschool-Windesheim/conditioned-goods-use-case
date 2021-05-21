/*eslint-disable*/
import React from "react";
import { Link } from "react-router-dom";
import useFetch, { Provider } from 'use-http'

import IndexNavbar from "components/Navbars/IndexNavbar.js";

function timeConverter(time){
  time = new Date(time);
  const hours = time.getHours()+ ":" + time.getMinutes()+ ":" + time.getSeconds();
  const day = time.getDate()+ "/" + time.getMonth() +"/"+ time.getFullYear();
  const newTime = hours + " " + day
  return(newTime);
}

function listViewOrdener(list){
  const newList = [];
  list.forEach(element => {
  const sensor = element + "; "    
  newList.push(sensor)
  });

  return(newList)
}

export default function Index() {
  const {loading, error, data = []} = useFetch('http://localhost:8080/shipments', {}, []);
  console.log(data);
  return (
    <>
      <IndexNavbar fixed />
      <section className="container header pt-20 flex h-screen max-h-860-px">
        <div className="container">
        <div className="block text-3xl mb-2">All shipments: </div>
          <table className="border-2 border-black w-full text-left ">
            <thead>
              <tr>
                <th className="border-2 border-black">Shipment</th>
                <th className="border-2 border-black">Sensors</th>
                <th className="border-2 border-black">Current sensor</th>
                <th className="border-2 border-black">Temperature</th>
                <th className="border-2 border-black">Timestamp</th>
                <th className="border-2 border-black">more</th>
              </tr>
            </thead>
            <tbody>
            {data.map(({id, temperature, sensors}) => 
              <tr key={id}>
                <td className="border-2 border-black">{id}</td> 
                <td className="border-2 border-black">{listViewOrdener(sensors)}</td>
                <td className="border-2 border-black">{temperature.sensorID}</td>
                <td className="border-2 border-black">{temperature.value}°C</td>
                <td className="border-2 border-black">{timeConverter(temperature.timestamp)} </td>
                <td className="border-2 border-black"><a href={"/singelShipment/" + id}>More Info</a></td>
              </tr>
            )}
            </tbody>
          </table>
        </div>
        <Link to="/AddShipment"><button>Add Shipment</button></Link>
      </section>
    </>
  );
}
