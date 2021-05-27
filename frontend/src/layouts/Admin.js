import React from "react";
import {Switch, Route, Redirect} from "react-router-dom";
import SnackbarProvider from "react-simple-snackbar"

// components
import AdminNavbar from "components/Navbars/AdminNavbar.js";
import Sidebar from "components/Sidebar/Sidebar.js";
import HeaderStats from "components/Headers/HeaderStats.js";
import FooterAdmin from "components/Footers/FooterAdmin.js";
import PaginationProvider from "components/Providers/Pagination.js";

// views
<<<<<<< Updated upstream
import Dashboard from "views/admin/Dashboard/index.js";
import Shipment from "views/admin/Shipment/index.js";
import AddShipment from "views/admin/AddShipment.js";
import Shipments from "views/admin/Shipments/index.js";
=======
import Dashboard from "views/admin/Dashboard.js";
// import Shipment from "views/admin/Shipment/index.js";
import AddShipment from "views/admin/AddShipment/index.js";
>>>>>>> Stashed changes

export default function Admin() {
  return (
    <>
    <SnackbarProvider>
      <Sidebar />
<<<<<<< Updated upstream
      <PaginationProvider className="h-full overflow-y-auto relative md:ml-64 bg-blueGray-100">
          <AdminNavbar />
          {/* Header */}
          <HeaderStats />
          <div className="px-4 md:px-10 mx-auto min-h-full w-full -m-24">
            <Switch>
              <Route path="/admin/dashboard" exact component={Dashboard} />
              <Route path="/admin/shipment/:id" exact component={Shipment} />
              <Route path="/admin/shipments" exact component={Shipments} />
              <Route path="/admin/shipment/add" exact component={AddShipment} />
              <Redirect from="/admin" to="/admin/dashboard" />
            </Switch>
            <FooterAdmin />
          </div>
      </PaginationProvider>
=======
      <div className="min-h-screen relative md:ml-64 bg-blueGray-100">
        <AdminNavbar />
        {/* Header */}
        <HeaderStats />
        <div className="px-4 md:px-10 mx-auto min-h-full w-full -m-24">
          <Switch>
            <Route path="/admin/dashboard" exact component={Dashboard} />
            <Route path="/admin/shipment/add" exact component={AddShipment} />
            {/* <Route path="/admin/shipment/:id" exact component={Shipment} /> */}
            <Redirect from="/admin" to="/admin/dashboard" />
          </Switch>
          <FooterAdmin />
        </div>
      </div>
    </SnackbarProvider>
>>>>>>> Stashed changes
    </>
  );
}
