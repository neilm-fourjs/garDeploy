
# Various GAR and GBC deployment automation examples

## Scripts

* garDeploy.sh: deploy a GAR to GAS via the secure deployment web service
* gbcDeploy.sh: deploy a GBC to GAS via the secure deployment web service
* getWSInfo.sh: get the GIP endpoints and the openapi json for your service
* getToken.bat: A starting point for creating a DOS version of the garDeploy script

## Genero example program

* Deploy.sh: a simple script to run the program in the directory where it's installed.
* Deploy.4gl: An Genero example program for deploying a gar or gbc file
* gar_api.4gl: Generated from openapi for the service
* gbc_api.4gl: Generated from openapi for the service
* example.json: An example of the server config file required for the Deploy.4gl program
* makefile: A simple makefile to build the 4gl example
* Make_fjs.inc: Include file for the makefile rules etc.

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

## Using the scripts

Update the values at the top of the garDeploy.sh script to your values.
```
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
CLIENTID= #< your client id >
SECRETID= #< your secret id >
GARNAME= #< your gar file name - without the .gar >
GASURL= #< your url for the gas, ie: https://<server>[:port]/[cgi alias]  >
SECURE= #< 1 or 0 - to secure the service behind GIP >
```


Update the values at the top of the gbcDeploy.sh script to your values.
```
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
CLIENTID= #< your client id >
SECRETID= #< your secret id >
GBCNAME= #< your gbc file name - without the .zip >
GASURL= #< your url for the gas, ie: https://<server>[:port]/[cgi alias]  >
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

## Using the Genero program

Build the program using:
```
$ make
```

To deploy a gar or gbc to a server you need to define the properties for the server in a json file, see the example.json supplied, then run the program like this:
```
<install folder>/Deploy.sh gar myapp.gar local.json
```
or
```
<install folder>/Deploy.sh gbc mygbc.zip local.json
```
It's possible run this from a custom action in GeneroStudio, you can create this from the Preferences->General->User Actions
![gstcustacc](https://github.com/neilm-fourjs/garDeploy/raw/master/gst_custom_action.png "GSTCUSTACC")
In the example above I'm using pi.json server config file to deploy to my Raspberry Pi.


