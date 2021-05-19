/*eslint-disable*/
import React from "react";
import {Link} from "react-router-dom";
import useFetch from 'use-http'
import {DateTime} from 'luxon';

// components
import CardTable from "components/Cards/CardTable.js";

const LABELS = ["Id", "Sensors", "Temperature", "Last updated", "Created on"];

export default function Dashboard() {
  const {loading, error, data = []} = useFetch('http://localhost:8080/shipments', {}, []);

  function renderRow({id, temperature, sensors, createdAt}, i) {
    const updated = DateTime.fromMillis(temperature?.timestamp);
    const created = DateTime.fromMillis(createdAt);

    return (
      <tr key={i}>
        <th className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4 text-left">
          <Link
            to={`/admin/shipment/${id}`}
            className="text-sm font-normal text-lightBlue-500"
          >
            #{id}
          </Link>
        </th>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {sensors.length}
        </td>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {temperature?.value || "-"}
        </td>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {updated.toFormat("dd-MM-yyyy HH:mm:ss")}
        </td>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {created.toFormat("dd-MM-yyyy HH:mm:ss")}
        </td>
      </tr>
    );
  }

  return (
    <>
      <CardTable labels={LABELS} items={data} renderItem={renderRow} />
    </>
  );
}
