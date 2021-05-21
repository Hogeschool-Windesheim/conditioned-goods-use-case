import React from "react";
import {BrowserRouter, Route, Switch, Redirect} from "react-router-dom";

// layouts
import Admin from "layouts/Admin.js";
import Auth from "layouts/Auth.js";
import AddShipment from "views/AddShipment";


export default function Main() {
    return (
        <BrowserRouter>
            <Switch>
            {/* add routes with layouts */}
            <Route path="/admin" component={Admin} />
            <Route path="/auth" component={Auth} />
            <Route path="/AddShipment" exact component={AddShipment} />
            {/* add redirect for first page */}
            <Redirect from="*" to="/admin/" />
            </Switch>
        </BrowserRouter>
    );
}