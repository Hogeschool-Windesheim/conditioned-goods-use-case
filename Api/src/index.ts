import express, {Request, Response} from "express";
import {validationResult} from "express-validator";
import dotenv from 'dotenv';
import {checkSchema} from 'express-validator';
import {getResolver, postResolver, routeSchemaValidation} from './routes';

dotenv.config();

const app = express();
app.use(express.json());

for (const [key, value] of Object.entries(postResolver)) {
  const schema = routeSchemaValidation[key];
  app.post(key, checkSchema(schema), (req: Request, res: Response)=>{
    validate(req, res);

    value(req, res);
  });
}

for (const [key, value] of Object.entries(getResolver)) {
  const schema = routeSchemaValidation[key];
  app.get(key, checkSchema(schema), (req: Request, res: Response)=>{
    validate(req, res);

    value(req, res);
  });
}

function validate(req: Request, res: Response){
  const errors = validationResult(req);
    if (!errors.isEmpty()){
      return res.status(400).json({
        errors: errors.array()
      })
    }
}

// start the Express server.
app.listen(process.env.PORT, () => {
    // tslint:disable-next-line:no-console
    console.log(`🚀 Server ready!`)
  });

export default app;