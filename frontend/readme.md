## Frontend
This repository contains a Dashboard build with ReactJS, which can be deployed on its own server.

## Getting Started
The steps below will help you setup a working copy of this repository running locally on your machine for development and testing purpose.

### Prerequisites
- Node;
- NPM or Yarn;
- Running API

### Installing the Frontend 
Installing and running the Frontend is pretty easy when following the following steps:

install the dependencies
```
yarn start
```
or
```
npm install
```
Copy the `.env-example` file and rename it to `.env` and fill in the variables to your own values. The values inside the `.env` file will be available in the code through `process.env.{variable_name}`. Registered variables are:
- REACT_APP_API_URL: Port of the API server (for example: http://localhost:8080).

### Running the Frontend
If all of the above requirements and step are followed it is possible to run the Frontend:

Run the following command:
```
npm run start
```

### Interaction with the Frontend

if everything was done correctly your preferred web browser should open up a tab with de frontend page while scripts are building the application.
once the scripts are done compiling the code, you should be able to see a list of shipments and a navbar with multiple options related to the shipments.
if the page is not popping up for whatever reason try opening it yourself by going to http://localhost:3000/

