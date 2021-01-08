Readme for final scripts.
These scripts can be used for deployment of the hyperledger fabric network.

However the scripts are incomplete in that way that you will encouter an error.
This error has not been resolved yet and there was also a stackoverflow post made on this matter. (https://stackoverflow.com/questions/65343145/hyperledger-fabric-err-bad-proposal-response-500-access-denied-when-trying)

To setup this all up make sure that you run the scripts in the following order:
	1. docker-prereq.sh
	2. spark-deployment.sh
	3. create_channel.sh

To run these scripts you copy the code inside or download them to your machine and make them executable by using: chmod +x filename.sh
Then you can execute them by using: ./filename.sh

These scripts have been tested on ubuntu 20.04 and docker version 20.10
On a machine with 2048MB RAM and 2 CPU cores. 

*** IMPORTANT ***
Older scripts have been added for reference when needed, but just keep in mind that these are not considered to be correct.
These can only be used in combination with de Hyperledger fabric documentation. Only reference these files when its absolutely needed.
We recommend using the scripts in the final scripts folder that was provided.