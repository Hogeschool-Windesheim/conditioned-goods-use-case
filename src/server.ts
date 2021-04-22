import app from './Api';

const server = app.listen(app.get("PORT"), () => {
    console.log(
        "App is running on http://localhost:%d in %s mode",
        app.get("PORT"),
        app.get("env")
    )
});

export default server;