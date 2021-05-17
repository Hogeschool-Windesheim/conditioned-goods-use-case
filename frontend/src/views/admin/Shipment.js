import React from "react";
import useFetch from 'use-http'

// components

import CardLineChart from "components/Cards/CardLineChart.js";
import CardBarChart from "components/Cards/CardBarChart.js";
import CardPageVisits from "components/Cards/CardPageVisits.js";
import CardSocialTraffic from "components/Cards/CardSocialTraffic.js";

const data = [
  {value: -5, sensorID: "0", timestamp: 1658809689 * 1000},
  {value: -20, sensorID: "0", timestamp: 1658820989 * 1000},
  {value: -15, sensorID: "0", timestamp: 1658840989 * 1000},
  {value: -12, sensorID: "0", timestamp: 1658855989 * 1000},
  {value: -8, sensorID: "0", timestamp: 1658860989 * 1000},
  {value: -20, sensorID: "1", timestamp: 1658809989 * 1000},
  {value: -7, sensorID: "1", timestamp: 1658820989 * 1000},
  {value: -18, sensorID: "1", timestamp: 1658849989 * 1000},
  {value: -16, sensorID: "1", timestamp: 1658850989 * 1000},
  {value: -25, sensorID: "1", timestamp: 1658860989 * 1000},
];

export default function Shipment() {
  // const {loading, error, data} = useFetch('http://localhost:8080/shipment/0/measurements', {}, []);

  //{
  //       label: `Sensor ${sensorID}`,
  //       backgroundColor: backgroundColor,
  //       borderColor: borderColor,
  //       data: values,
  //       fill: false,
  //     } 

  function orderData() {
      const groups = {};
      const labels = []

      data.sort((date1, data2) => data2.timestamp + date1.timestamp);

      data.forEach(({sensorID, timestamp, value}) => {
        let group = groups[sensorID] || {label: `Sensor ${sensorID}`, data: [],  backgroundColor: "#4c51bf",
    borderColor: "#4c51bf", fill: false};
        // let group = groups[sensorID] || {sensorID: data.sensorID, values: []};
        groups[sensorID] = {...group, data: [...group.data, value]};

        let date = new Date(timestamp).getHours() + ":00";

        if (!labels.includes(date)) labels.push(date);
      });

      return {dataset: Object.values(groups), labels: labels};
  }

  // const labels = [
  //   "Date1",
  //   "Date2",
  //   "Date3",
  //   "Date4",
  //   "Date 5",
  // ]
  const {dataset, labels} = orderData();
  
  return (
    <>
      <div className="flex flex-wrap">
        <div className="w-full xl:w-4/12 px-4">
          <CardBarChart />
        </div>
        <div className="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
          <CardLineChart title="Temperature" subtitle="History" labels={labels} dataset={dataset} />
        </div>
      </div>
      <div className="flex flex-wrap mt-4">
        <div className="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
          <CardPageVisits />
        </div>
        <div className="w-full xl:w-4/12 px-4">
          <CardSocialTraffic />
        </div>
      </div>
    </>
  );
}
