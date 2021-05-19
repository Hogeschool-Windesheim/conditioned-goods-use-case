import React, {Fragment, useEffect, useState} from "react";
import useFetch from 'use-http';
import {DateTime} from 'luxon';

// components
import CardLineChart from "components/Cards/CardLineChart.js";
import CardBarChart from "components/Cards/CardBarChart.js";
import CardPageVisits from "components/Cards/CardPageVisits.js";
import CardSocialTraffic from "components/Cards/CardSocialTraffic.js";

// const data = [
//   {value: -5, sensorID: "0", timestamp: 1658809689 * 1000},
//   {value: -20, sensorID: "0", timestamp: 1658820989 * 1000},
//   {value: -15, sensorID: "0", timestamp: 1658840989 * 1000},
//   {value: -12, sensorID: "0", timestamp: 1658855989 * 1000},
//   {value: -8, sensorID: "0", timestamp: 1658860989 * 1000},
//   {value: -20, sensorID: "1", timestamp: 1658809989 * 1000},
//   {value: -7, sensorID: "1", timestamp: 1658820989 * 1000},
//   {value: -18, sensorID: "1", timestamp: 1658849989 * 1000},
//   {value: -16, sensorID: "1", timestamp: 1658850989 * 1000},
//   {value: -25, sensorID: "1", timestamp: 1658860989 * 1000},
// ];

function TestCard({value}) {
  return (
      <div className="relative flex flex-col min-w-0 break-words bg-white w-full mb-6 shadow-lg rounded">
        <div className="rounded-t mb-0 px-4 py-3 bg-transparent">
          <div className="flex flex-wrap items-center">
            <div className="relative w-full max-w-full flex-grow flex-1">
              <h6 className="uppercase text-blueGray-400 mb-1 text-xs font-semibold">
                Current value
              </h6>
              <h2 className="text-blueGray-700 text-xl font-semibold">
                Last Measurement
              </h2>
            </div>
          </div>
        </div>
        <div className="p-4 flex justify-center">
          <p className="text-6xl text-black font-medium">{value}</p>
          <div class="border-solid"></div>
        </div>
      </div>
  );
}

export default function Shipment() {
  const {data} = useFetch('http://localhost:8080/shipment/0/measurements', {}, []);
  const {data: currrent} = useFetch('http://localhost:8080/shipment/0/measurement', {}, []);

  const [dataset, setDataset] = useState();

  function orderData() {
      const groups = {};
      const labels = []

      data?.sort((date1, data2) => data2.timestamp + date1.timestamp);

      data?.forEach(({sensorID, timestamp, value}) => {
        let group = groups[sensorID] || {label: `Sensor ${sensorID}`, data: [],  backgroundColor: "#4c51bf",
    borderColor: "#4c51bf", fill: false};
    
        groups[sensorID] = {...group, data: [...group.data, value]};

        let date = new Date(timestamp).getHours() + ":00";

        if (!labels.includes(date)) labels.push(date);
      });

      return {dataset: Object.values(groups), labels: labels};
  }

  useEffect(() => {
    const sorted = orderData();

    setDataset(sorted);
  }, [data]);

  function renderRow({sensorID, timestamp, value}) {
    const date = DateTime.fromMillis(timestamp);
    return (
      <tr>
        <th className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4 text-left">
          {sensorID}
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
          <TestCard value={currrent?.value} />
        </div>
        <div className="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
          <CardLineChart title="Temperature" subtitle="History" labels={dataset?.labels} dataset={dataset?.dataset} />
        </div>
      </div>
      <div className="flex flex-wrap mt-4">
        <div className="w-full px-4">
          <CardPageVisits title="Measurements" labels={["Sensor", "value", "timestamp"]} items={data} renderItem={renderRow} />
        </div>
      </div>
    </>
  );
}
