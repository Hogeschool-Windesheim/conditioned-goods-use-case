## RestApi
An Restfull Api developed as an express app, which can bedeployed on its own server.

## Getting Started
The steps below will help you setup a working copy of this repository running locally on your machine for development and testing purpose.

### Prerequisites
- Docker (desktop);
- Node;
- NPM or Yarn;

### Installing the Api 
Installing and running Api is pretty easy when following the following steps:

install the dependencies
```
yarn
```
or
```
npm install
```
Copy the `.env-example` file and rename it to `.env` and fill in the environment to your own values. The values inside the `.env` file will be available in the code through `process.env.{variable_name}`. Registered variables are:
- PORT: Port of the server (for example: 8080).

### Running the Api
If all of the abouve requirements and step are followed it is possible to run the Api:

Run the follwing command:
```
npm run start
```

### Interact with the Api

Interacting with the Api is possible trough postman, the IBM Blockchain Platform(see readme in the chaincode file) or bij running the frontend environment that is part of this project. 