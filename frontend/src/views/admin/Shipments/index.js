import React from "react";
import {Link} from "react-router-dom";
import {DateTime} from 'luxon';
import useShipments from './containerHook';

// components
import CardTable from "components/Cards/CardTable.js";
import Pagination from "components/Pagination.js";

const LABELS = ["Id", "Sensors", "Temperature", "Last updated", "Created on"];

/** 
 * Shipments page
 */
export default function Shipments() {
  const {data, canFetch, onFetchMore} = useShipments();

  function renderRow({id, temperature, sensors, createdAt}, i) {
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
          {temperature?.timestamp ? DateTime.fromMillis(temperature?.timestamp).toFormat("dd-MM-yyyy HH:mm:ss") : '-'}
        </td>
        <td className="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4">
          {DateTime.fromMillis(createdAt).toFormat("dd-MM-yyyy HH:mm:ss")}
        </td>
      </tr>
    );
  }

  return (
    <Pagination canFetch={canFetch} fetchMore={onFetchMore}>
      <p className="text-white font-semibold uppercase mb-2">Shipments</p>
      <CardTable labels={LABELS} items={data.result} renderItem={renderRow} />
    </Pagination>
  );
}
