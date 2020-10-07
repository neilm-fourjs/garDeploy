#!/bin/bash

# All these value must be set correctly before the script will work.
SETUP=0 # IMPORTANT: change this to 1 when you have updated the values below!
CLIENTID= #< your client id >
SECRETID= #< your secret id >
GARNAME= #< your gar file name - without the .gar >
GASURL= #< your url for the gas, ie: https://<server>[:port]/[cgi alias]  >
SECURE= #< 1 or 0 - to secure the service behind GIP >

# These values shouldn't need to be changed.
GETTOKEN=$FGLDIR/web_utilities/services/gip/bin/gettoken/GetToken.42r
DEPLOYGAR=$FGLDIR/web_utilities/services/gip/bin/deploy/DeployGar.42r
FILE=./deploy.tok
WSSCOPE="deployment registar"
GARFILE=distbin/${GARNAME}.gar
LOG=garDeploy.log
unset FGLPROFILE

# Sanity checks.
if [ $SETUP -eq 0 ]; then
	echo "This script has not be configured yet!"
	exit 1
fi

if [ -z $FGLDIR ]; then
	echo "FGLDIR is not set!"
	exit 1
fi

if [ ! -e $GARFILE ]; then
	echo "Gar file '$GARFILE' is missing!"
	exit 1
fi

# clear the log file if it exists
rm -f $LOG

# Get a token if we don't have a recent one.
if [ "$(find $FILE -mmin +9)" ] || [ ! -e $FILE ]; then
	echo "Getting new token file: $FILE."
	fglrun $GETTOKEN client_credentials --client_id $CLIENTID --secret_id $SECRETID --idp $GASURL/ws/r/services/GeneroIdentityProvider --savetofile $FILE $WSSCOPE >> $LOG
else
	echo "Using existing token file: $FILE."
fi
if [ ! -e $FILE ]; then
	echo "Failed to get token!"
	exit 1
fi

# Get list of deployed gar's - mainly to check our access is working.
echo "Getting deployed list / checking access ..."
fglrun $DEPLOYGAR list --xml --tokenfile $FILE $GASURL > deployed.list
if [ $? -ne 0 ]; then
	echo "Failed to get deployed list!"
	exit 1
fi

# Check if already deployed and try and undeploy it.
deployed=$( grep ARCHIVE deployed.list | grep $GARNAME >> $LOG )
if [ $? -eq 0 ]; then
	echo "Gar already deployed, attempting to disable and undeploy ..."
	echo "Disable $GARNAME ..."
	fglrun $DEPLOYGAR disable -f $FILE $GARNAME $GASURL >> $LOG
	echo "Undeploy $GARNAME ..."
	fglrun $DEPLOYGAR undeploy -f $FILE $GARNAME $GASURL >> $LOG
fi

# Deploy / Secure / Enable
echo "Deploy $GARNAME ..."
fglrun $DEPLOYGAR deploy -f $FILE $GARFILE $GASURL >> $LOG
if [ $? -ne 0 ]; then
	echo "Failed!"
	exit 1
else
	echo "Okay"
fi

if [ $SECURE -eq 1 ]; then
	echo "Secure $GARNAME ..."
	fglrun $DEPLOYGAR secure  -f $FILE $GARNAME $GASURL >> $LOG
	if [ $? -ne 0 ]; then
		echo "Failed!"
		exit 1
	else
		echo "Okay"
	fi
fi

echo "Enable $GARNAME ..."
fglrun $DEPLOYGAR enable  -f $FILE $GARNAME $GASURL >> $LOG
if [ $? -ne 0 ]; then
	echo "Failed!"
	exit 1
else
	echo "Okay"
fi

fglrun $DEPLOYGAR list --xml --tokenfile $FILE $GARURL | grep ARCHIVE | grep $GARNAME
echo "Finished."

