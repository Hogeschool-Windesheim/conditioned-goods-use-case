import express from "express";
import dotenv from 'dotenv';
import {getResolver, postResolver} from './routes';

dotenv.config();

const app = express();
app.use(express.json());

// Register api routes.
for (const [key, value] of Object.entries(getResolver)) {
    app.get(key, value);
}

for (const [key, value] of Object.entries(postResolver)) {
  app.post(key, value);
}

// start the Express server.
app.listen(process.env.PORT, () => {
    // tslint:disable-next-line:no-console
    console.log(`🚀 Server ready on http://localhost:`+process.env.PORT+` !`)
  });

export default app;