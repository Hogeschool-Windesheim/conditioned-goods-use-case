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
          <table className="table-fixed border-2 border-black w-max">
            <thead>
              <tr>
                <th className="border-2 border-black w-1/7">Id</th>
                <th className="border-2 border-black w-1/7">Sensors</th>
                <th className="border-2 border-black w-1/7">Current sensor</th>
                <th className="border-2 border-black w-1/7">Temperature</th>
                <th className="border-2 border-black w-1/7">Timestamp</th>
                <th className="border-2 border-black w-1/7">more</th>
              </tr>
            </thead>
            <tbody>
            {data.map(({id, temperature, sensors}) => 
              <tr key={id}>
                <td>{id}</td> 
                <td>{listViewOrdener(sensors)}</td>
                <td>{temperature.sensorID}</td>
                <td>{temperature.value}°C</td>
                <td>{timeConverter(temperature.timestamp)} </td>
                <td><Link to="/views/singelShipment"><button>More info</button></Link></td>
              </tr>
            )}
            </tbody>
          </table>
          
        </div>
      </section>
    </>
  );
}
