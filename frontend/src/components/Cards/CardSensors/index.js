import React from "react";
import useAddShipment from './containerHook.js';

// components
import CardTable from "components/Cards/CardTable.js";


/** 
 * Render row inside the sensor table card.
 */
 function sensorRenderRow(sensor, i) {
  return (
    <tr key={i}>
      <th className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4 text-left">
        #{sensor}
      </th>
    </tr>
  );
}

export default function CardSensors({sensors, addSensor}){
  const {form, onSubmit, onChange} = useAddShipment(addSensor);
  const addSensorForm = 
  <div>
    <form onSubmit={onSubmit}>
      <div className="pb-2 pr-2 inline-block">
        <input value={form.sensorID} name="sensorID" onChange={onChange} type="text" placeholder="New sensor id" className="form-input border rounded" />
      </div>
      <div className="pb-2 pr-2 inline-block">
        <button type="submit" className="bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded">
          Add Sensor
        </button>
      </div>
    </form>
  </div>
  ;

  return <CardTable title="Sensors" items={sensors} renderItem={sensorRenderRow} AddFunction={addSensorForm}/>
}