import { app } from "./index";

const port = process.env.PORT || 3000;

// Start the Express server.
app.listen(port, () => {
    console.log(`🚀 Server ready on http://localhost:${port}!`);
});
