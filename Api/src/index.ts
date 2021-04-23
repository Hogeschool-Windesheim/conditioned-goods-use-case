import express from "express";
import dotenv from 'dotenv';
dotenv.config();

// require('dotenv').config();
const port = process.env.PORT;

const app = express();

// define route for the default home page
app.get('/', (req, res) => {
    res.send("Hello World, from hyperledgerfabric Conditionedgoods!");
});

// start the Express server
app.listen(port, () => {
    // tslint:disable-next-line:no-console
    console.log(`App is running on http://localhost:${port}`)
  });

export default app;