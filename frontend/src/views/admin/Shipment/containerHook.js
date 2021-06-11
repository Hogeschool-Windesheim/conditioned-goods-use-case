import {useEffect, useState} from 'react';
import {useParams} from "react-router-dom";
import useFetch from 'use-http';
import {randomColor} from "libs/color.js";

/** 
 * Hook to handle shipment functionalities.
 */
export default function useShipment() {
    const {id} = useParams();
    const {data: shipment} = useFetch(`/shipment/${id}`, {}, [id]);
    const {data: measurements} = useFetch(`/shipment/${id}/measurements`, {}, [id]);

    const [chartData, setChartData] = useState();

    /** 
     * Order data on sensorID.
     */
    function orderData(measurements) {
        // Sensor groups.
        const groups = {};

        // Sort measurements on timestamp. 
        measurements?.sort((date1, data2) => data2.timestamp + date1.timestamp);

        // Loop through all measurements.
        measurements?.forEach(({sensorID, timestamp, value}) => {
            // Get a random color.
            let color = randomColor();

            // Check if there is a group for the sensorID, otherwise make one.
            let group = groups[sensorID] || {label: `Sensor ${sensorID}`, data: [],  backgroundColor: color, borderColor: color, fill: false};

            // Add measurements to sensor group. 
            groups[sensorID] = {...group, data: [...group.data, {x: timestamp,y: value}]};
        });

        // Return groups as an array.
        return Object.values(groups);
  }

  useEffect(() => {
    const chartData = orderData(measurements);

    setChartData(chartData);
  }, [measurements]);

  return {
      shipment, 
      chartData, 
      measurements
    }
}