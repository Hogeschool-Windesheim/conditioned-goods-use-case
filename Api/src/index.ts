import express from "express";
import dotenv from 'dotenv';
dotenv.config();

const app = express();

// define route for the default home page
app.get('/', (req, res) => {
    res.send("Hello World, from hyperledgerfabric Conditionedgoods!");
});

// start the Express server
app.listen(process.env.PORT, () => {
    // tslint:disable-next-line:no-console
    console.log(`App is running on http://localhost:${process.env.PORT}`)
  });

export default app;