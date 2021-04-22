"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const app = express();
app.set("PORT", process.env.PORT || 3000);
app.get('/', (req, res) => {
    res.send("Hello World, from hyperledgerfabric Conditionedgoods!");
});
exports.default = app;
//# sourceMappingURL=Api.js.map