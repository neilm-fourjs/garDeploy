# garDeploy.sh & getWSInfo.sh

garDeploy.sh: deploy a GAR to GAS via the deployment web service

getWSInfo.sh: get the GIP endpoints and the openapi json for your service

getToken.bat: A starting point for creating a DOS version of the garDeploy script


## Requirements:

GAS 3.20 > 

FGL 3.20 >

GAS should be running and the GIP should be setup.

You must create the 'service to service app' in the consoleApp
This will show you the ClientID and SecretID you need.
Give it the scopes of: 
```
deployment register
```


Search GAS manual for 'automatize deployment'

Update the values at the top of the garDeploy.sh script to your values.
```
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
CLIENTID= #< your client id >
SECRETID= #< your secret id >
GARNAME= #< your gar file name - without the .gar >
GASURL= #< your url for the gas, ie: https://<server>[:port]/[cgi alias]  >
SECURE= #< 1 or 0 - to secure the service behind GIP >
```

Update the values at the top of the getWSInfo.sh script.
```
GASURL=https://<YOUR SERVER>/<GAS ALIAS>
CLIENTID=<YOUR SERVICE TO SERVICE APP CLIENTID>
SECRETID=<YOUR SERVICE TO SERVICE APP SECRETID>
XCF=<THE NAME OF YOUR XCF FILE excluding the .xcf>
SRV=<YOUR SERVICE NAME>
WSSCOPE="<YOUR SCOPES>"
```

