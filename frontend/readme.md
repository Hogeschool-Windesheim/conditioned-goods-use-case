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
yarn
```
or
```
npm install
```
Copy the `.env-example` file and rename it to `.env` and fill in the variables to your own values. The values inside the `.env` file will be available in the code through `process.env.{variable_name}`. Registered variables are:
- REACT_APP_API_URL: Port of the API server (for example: http://localhost:8080).

### Running the Frontend
If all of the above requirements and step are followed it is possible to run the Frontend:

Run the follwing command:
```
npm run start
```

### Interaction with the Frontend

if everything was done correctly your preferred web browser should open up a tab with de frontend page while scripts are building the application.
once the scripts are done compiling the code, you should be able to see a list of shipments and a navbar with multiple options related to the shipments.
if the page is not popping up for whatever reason try opening it yourself by going to http://localhost:3000/

### Other problications
[pagina werkt zonder api, maar tegelijkertijd is er niets./]
when the first page loads in without any shipments one of two possiblities are possible, either you have not added any shipments yet or there is a problem with the API.

the first problem is easy to fix, navigate to the `Add Shipment` page and manualy add a shipment. If this is done correctly, you should be redirected to the information page of the specific shipment you just created. when you navigate back to the `Dashboard` or `All Shipments` page the shipments should be displayed in a table.

The second problem may be a bit more difficult to solve. the most likely problem would be that the API is not running yet, or you might have changed the PORT of your API and forgotten to change the REACT_APP_API_URL variable. we also recommend double checking whether or not the chain code is properly running in the IBM blockchain platform or not(Check API ReadMe). When all else fails the problem could be one of many thing, check the terminal of your API to determine the error and try to fix this on your own accord.

