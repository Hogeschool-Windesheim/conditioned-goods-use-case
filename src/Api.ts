import express = require("express");

const app = express();
app.set("PORT", process.env.PORT || 3000);

app.get('/', (req, res) => {
    res.send("Hello World, from hyperledgerfabric Conditionedgoods!");
});

export default app;