import React from "react";
import useFetch from 'use-http'

// components

import CardLineChart from "components/Cards/CardLineChart.js";
import CardBarChart from "components/Cards/CardBarChart.js";
import CardPageVisits from "components/Cards/CardPageVisits.js";
import CardSocialTraffic from "components/Cards/CardSocialTraffic.js";

export default function Shipment() {
  // const {loading, error, data} = useFetch('http://localhost:8080/shipment/2/measurements', {}, []);

  // console.log(data);

  return (
    <>
      <div className="flex flex-wrap">
        <div className="w-full xl:w-4/12 px-4">
          <CardBarChart />
        </div>
        <div className="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
          <CardLineChart title="Temperature" subtitle="History" />
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
