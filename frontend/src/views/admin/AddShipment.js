/*eslint-disable*/
import React, { useEffect, useState } from "react";

//components
import IndexNavbar from "components/Navbars/IndexNavbar.js";
import { bottom } from "@popperjs/core";
import CardAddShipment from "components/Cards/CardAddShipment.js";

export default function AddShipment() {
  return (
    <>
      <div className="w-full px-4">
            <CardAddShipment/>
      </div>
    </>
  );
}
