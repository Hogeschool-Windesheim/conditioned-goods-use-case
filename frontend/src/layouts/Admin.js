import React from "react";
import {Switch, Route, Redirect} from "react-router-dom";

// components
import AdminNavbar from "components/Navbars/AdminNavbar.js";
import Sidebar from "components/Sidebar/Sidebar.js";
import HeaderStats from "components/Headers/HeaderStats.js";
import FooterAdmin from "components/Footers/FooterAdmin.js";
import PaginationProvider from "components/Providers/Pagination.js";

// views
import Dashboard from "views/admin/Dashboard/index.js";
import Shipment from "views/admin/Shipment/index.js";

export default function Admin() {
  return (
    <>
      <Sidebar />
      <PaginationProvider className="h-full overflow-y-auto relative md:ml-64 bg-blueGray-100">
          <AdminNavbar />
          {/* Header */}
          <HeaderStats />
          <div className="px-4 md:px-10 mx-auto min-h-full w-full -m-24">
            <Switch>
              <Route path="/admin/dashboard" exact component={Dashboard} />
              <Route path="/admin/shipment/:id" exact component={Shipment} />
              <Redirect from="/admin" to="/admin/dashboard" />
            </Switch>
            <FooterAdmin />
          </div>
      </PaginationProvider>
    </>
  );
}
