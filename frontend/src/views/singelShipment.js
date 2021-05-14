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
  console.log(list);
  const newList = [];
  list.forEach(element => {
  const sensor = element + "; "    
  newList.push(sensor)
  });

  return(newList)
}

export default function Index() {
  const {loading, error, data = []} = useFetch('http://localhost:8080/shipments/'+ shipment , {}, []);
  console.log(data);
  return (
    <>
      <IndexNavbar fixed />
      <section className="container header pt-20 flex h-screen max-h-860-px">
        <div className="container">
        <div className="block text-3xl mb-2">All shipments: </div>
          {data.map(({id, temperature, sensors}, i) => 
            <div key={i} className="shipments"> 
              <div>Id: {id}</div> 
              <div>Sensors: {listViewOrdener(sensors)}</div>
              <div>Current sensorID: {temperature.sensorID}</div>
              <div>Temperature: {temperature.value}°C</div>
              <div>Timestamp: {timeConverter(temperature.timestamp)} </div>
              <button value={id}>more info</button>
            </div>
          )}
          
        </div>
      </section>
    </>
  );
}
