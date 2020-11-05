#!/bin/bash

# All these value must be set correctly before the script will work.
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
GASURL= #< your GAS url >
CLIENTID= #< your client id >
SECRETID= #< your secret id >
TOKENFILE=./local.tok

GBCNAME= #< your gbc file name - without the .zip >

# These values shouldn't need to be changed.
GETTOKEN=$FGLDIR/web_utilities/services/gip/bin/gettoken/GetToken.42r
DEPLOYGBC=$FGLDIR/web_utilities/services/gip/bin/deploy/DeployGbc.42r
WSSCOPE="deployment register"
GBCFILE=${GBCNAME}.zip
LOG=gbcDeploy.log
unset FGLPROTOKENFILE

# Sanity checks.
if [ $SETUP -eq 0 ]; then
	echo "This script has not be configured yet!"
	exit 1
fi

if [ -z $FGLDIR ]; then
	echo "FGLDIR is not set!"
	exit 1
fi

if [ ! -e $GBCFILE ]; then
	echo "Zip file '$GBCFILE' is missing!"
	exit 1
fi

# clear the log file if it exists
rm -f $LOG

# Get a token if we don't have a recent one.
if [ "$(find $TOKENFILE -mmin +9)" ] || [ ! -e $TOKENFILE ]; then
	echo "Getting new token file: $TOKENFILE."
	echo "fglrun $GETTOKEN client_credentials --client_id $CLIENTID --secret_id $SECRETID --idp $GASURL/ws/r/services/GeneroIdentityProvider --savetofile $TOKENFILE $WSSCOPE >> $LOG"
	fglrun $GETTOKEN client_credentials --client_id $CLIENTID --secret_id $SECRETID --idp $GASURL/ws/r/services/GeneroIdentityProvider --savetofile $TOKENFILE $WSSCOPE >> $LOG
else
	echo "Using existing token file: $TOKENFILE."
fi
if [ ! -e $TOKENFILE ]; then
	echo "Failed to get token!"
	exit 1
fi

# Get list of deployed GBC's - mainly to check our access is working.
echo "Getting deployed list / checking access ..."
fglrun $DEPLOYGBC list --xml --tokenfile $TOKENFILE $GASURL > deployed_gbc.list
if [ $? -ne 0 ]; then
	echo "Failed to get deployed list!"
	cat deployed_gbc.list
	exit 1
fi

# Check if already deployed and try and undeploy it.
deployed=$( grep "<GBC>" deployed_gbc.list | grep $GBCNAME >> $LOG )
if [ $? -eq 0 ]; then
	echo "GBC already deployed, attempting to disable and undeploy ..."
	echo "Undeploy $GBCNAME ..."
	fglrun $DEPLOYGBC undeploy -f $TOKENFILE $GBCNAME $GASURL >> $LOG
fi

#rm deployed_gbc.list

# Deploy / Secure / Enable
echo "Deploy $GBCNAME ..."
fglrun $DEPLOYGBC deploy -f $TOKENFILE $GBCFILE $GASURL >> $LOG
if [ $? -ne 0 ]; then
	echo "Failed!"
	exit 1
else
	echo "Okay"
fi

#fglrun $DEPLOYGBC config -f $TOKENFILE -c ${GBCNAME}.json get $APPCLIENTID $GASURL/
#echo fglrun $DEPLOYGBC list --xml --tokenfile $TOKENFILE $GASURL
fglrun $DEPLOYGBC list --xml --tokenfile $TOKENFILE $GASURL > deployed_gbc.list
echo "Finished."

