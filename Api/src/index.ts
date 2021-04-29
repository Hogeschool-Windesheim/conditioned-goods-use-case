import express from "express";
import dotenv from 'dotenv';
import {routeResolver} from './routes';

dotenv.config();

const app = express();

// Register api routes.
for (const [key, value] of Object.entries(routeResolver)) {
    app.get(key, value);
}

// start the Express server.
app.listen(process.env.PORT, () => {
    // tslint:disable-next-line:no-console
    console.log(`🚀 Server ready!`)
  });

export default app;