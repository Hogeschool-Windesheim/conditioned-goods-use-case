sudo ./network.sh down 
sudo ./network.sh up -ca
sudo ./network.sh createChannel -c lwm-dlg-lng
sudo ./network.sh deployCC -c lwm-dlg-lng -ccn basic -ccs 1 -ccp ../chaincode -ccl typescript
