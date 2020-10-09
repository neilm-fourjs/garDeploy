#!/bin/bash

# Your Configuration Information
GASURL=https://<YOUR SERVER>/<GAS ALIAS>/ws/r
CLIENTID=<YOUR SERVICE TO SERVICE APP CLIENTID>
SECRETID=<YOUR SERVICE TO SERVICE APP SECRETID>
XCF=<THE NAME OF YOUR XCF FILE excluding the .xcf>
SRV=<YOUR SERVICE NAME>
WSSCOPE="<YOUR SCOPES>"

# Static variables
FILE=$SRV.tok
GETTOKEN=$FGLDIR/web_utilities/services/gip/bin/gettoken/GetToken.42r
IDP=$GASURL/services/GeneroIdentityProvider
OPENIDCFG=$GASURL/services/GeneroIdentityProvider/.well-known/openid-configuration
APIJSON=$GASURL/$XCF/$SRV?openapi.json

# Get a token if we don't have a recent one.
if [ "$(find $FILE -mmin +9)" ] || [ ! -e $FILE ]; then
  echo "Getting new token file: $FILE."
  fglrun $GETTOKEN client_credentials --client_id $CLIENTID --secret_id $SECRETID --idp $IDP --savetofile $FILE $WSSCOPE
else
  echo "Using existing token file: $FILE."
fi
if [ ! -e $FILE ]; then
  echo "Failed to get token!"
  exit 1
fi

TOK=$(cat $FILE)

# Get the GIP endpoints
echo ""
echo "wget --header=\"Authorization: Bearer $TOK\" $OPENIDCFG"
wget -O gip_endpoints.json --header="Authorization: Bearer $TOK" $OPENIDCFG

# Get the service openapi.json
echo ""
echo "wget --header=\"Authorization: Bearer $TOK\" $APIJSON"
wget -O ${SRV}_api.json --header="Authorization: Bearer $TOK" $APIJSON


