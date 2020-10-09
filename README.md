# garDeploy.sh
deploy a GAR to GAS via the deployment web service

## Requirements:

GAS 3.20 > 

FGL 3.20 >

GAS should be running and the GIP should be setup.

You must create the 'service to service app' in the consoleApp and give it the scopes of: deployment register
This will show you the ClientID and SecretID you need.

Search GAS manual for 'automatize deployment'

Update the values at the top of the script
```
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
CLIENTID= #< your client id >
SECRETID= #< your secret id >
GARNAME= #< your gar file name - without the .gar >
GASURL= #< your url for the gas, ie: https://<server>[:port]/[cgi alias]  >
SECURE= #< 1 or 0 - to secure the service behind GIP >
```

