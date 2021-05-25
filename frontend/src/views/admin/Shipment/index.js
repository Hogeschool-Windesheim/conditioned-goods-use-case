import React, {Fragment} from "react";
import {DateTime} from 'luxon';
import useShipment from './containerHook.js';

// components
import CardLineChart from "components/Cards/CardLineChart.js";
import CardTable from "components/Cards/CardTable.js";
import CardShipment from "components/Cards/CardShipment.js";

const LABELS = ["Sensor", "value", "timestamp"];

/** 
 * Shipment page.
 */
export default function Shipment() {
  const {shipment, measurements, chartData} = useShipment();

  /** 
   * Render row inside the table card.
   */
  function renderRow({sensorID, timestamp, value}, i) {
    const date = DateTime.fromMillis(timestamp);
    
    return (
      <tr key={i}>
        <th className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4 text-left">
          #{sensorID}
        </th>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {value}
        </td>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {date.toFormat("dd-MM-yyyy HH:mm:ss")}
        </td>
      </tr>
    );
  }
  
  return (
    <>
      <div className="flex flex-wrap">
        <div className="w-full xl:w-4/12 px-4">
            <CardShipment shipment={shipment} />
        </div>
        <div className="w-full xl:w-8/12 xl:mb-0 px-4">
          <CardLineChart title="Temperature" subtitle="History" dataset={chartData} />
        </div>
      </div>
      <div className="flex flex-wrap">
        <div className="w-full px-4">
          <CardTable title="Measurements" labels={LABELS} items={measurements} renderItem={renderRow} />
        </div>
      </div>
    </>
  );
}
