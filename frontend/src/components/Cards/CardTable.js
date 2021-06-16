import React from "react";

export default function CardMeasurementTable({title, labels = [], items = [], renderItem, AddFunction}) {
  return (
    <>
      <div className="relative flex flex-col min-w-0 break-words bg-white w-full mb-6 shadow-lg rounded">
          <div className="pl-4 pt-3">
            {AddFunction}
            <div className="flex relative w-full max-w-full flex-grow">
              <h3 className="font-semibold text-base text-blueGray-700">
                {title}
              </h3>
            </div>
          </div>
        <div className="block w-full overflow-x-auto">
          <table className="items-center w-full bg-transparent border-collapse">
            <thead>
              <tr>
                {labels.map((label, i) => 
                   <th key={i} className="px-6 bg-blueGray-50 text-blueGray-500 align-middle border border-solid border-blueGray-100 py-3 text-xs uppercase border-l-0 border-r-0 whitespace-nowrap font-semibold text-left">
                    {label}
                  </th>
                )}
              </tr>
            </thead>
            <tbody>
              {items.map((item, i) => renderItem(item, i))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}
