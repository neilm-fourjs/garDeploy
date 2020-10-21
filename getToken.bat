REM
REM get token from this server
set SRV=https://< server name>/<gas alias>
REM The client/secret ids for the deployment 'Service to Service App'
set CLIENTID=< client id >
set SECRETID=< secret id >
set SCOPES="deployment register"
REM  
REM set the environment for GIP if it's local ?
REM call "%FGLDIR%\web_utilities\services\gip\envidp.bat"
REM
REM Setup the command line programs
set GETTOKEN="%FGLDIR%\web_utilities\services\gip\bin\gettoken\GetToken.42r"
set DEPLOYGAR="%FGLDIR%\web_utilities\services\gip\bin\deploy\DeployGar.42r"
REM get the token using the 'Service to Service App' credentials.
call fglrun %GETTOKEN% client_credentials --idp %SRV%/ws/r/services/GeneroIdentityProvider --savetofile token.json --client_id %CLIENTID% --secret_id %SECRETID% %SCOPES%
REM get the list of deployed apps 
REM 
REM List the deployed GAR packages
REM call fglrun %DEPLOYGAR% list -f token.json %SRV%
REM
