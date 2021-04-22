"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Api_1 = require("./Api");
const server = Api_1.default.listen(Api_1.default.get("PORT"), () => {
    console.log("App is running on http://localhost:%d in %s mode", Api_1.default.get("PORT"), Api_1.default.get("env"));
});
exports.default = server;
//# sourceMappingURL=server.js.map