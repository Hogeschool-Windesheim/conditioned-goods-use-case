import {app} from './index';

// start the Express server.
app.listen(process.env.PORT, () => {
    // tslint:disable-next-line:no-console
    console.log(`🚀 Server ready on http://localhost:${process.env.PORT}!`)
});