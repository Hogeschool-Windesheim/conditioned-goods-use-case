import app from '.';
require('dotenv').config();
let port = process.env.PORT;

const server = app.listen(port, () => {
    console.log(
        "App is running on http://localhost:"+ port,
        app.get(port),
        app.get("env")
    )
});

export default server;