IMPORT os
IMPORT util
IMPORT xml
IMPORT FGL OAuthAPI

-- Generated from openapi spec for the gar deployment service
IMPORT FGL gar_api
-- Generated from openapi spec for the gbc deployment service
IMPORT FGL gbc_api

CONSTANT C_GAR_ENDPOINT = "/ws/r/admin/GeneroDeploymentService/gar"
CONSTANT C_GBC_ENDPOINT = "/ws/r/admin/GeneroDeploymentService/gbc"

DEFINE m_server RECORD
	name STRING,
	url STRING,
	cli_id STRING,
	secret STRING,
	scopes STRING,
	connTimeout SMALLINT,
	token STRING,
	tokenExpires STRING
	END RECORD

DEFINE m_message STRING
MAIN
	DEFINE l_gar BOOLEAN
	DEFINE l_file STRING
	DEFINE l_stat SMALLINT
	
	IF NUM_ARGS() < 3 THEN
		CALL invalidArgs("Not enough args")
	END IF

	CASE ARG_VAL(1)
		WHEN "gar" LET l_gar = TRUE
		WHEN "gbc" LET l_gar = FALSE
		OTHERWISE CALL invalidArgs("Invalid args")
	END CASE
	LET l_file = ARG_VAL(2)
	IF l_file.getLength() < 2 THEN CALL invalidArgs("Wrong number of args") END IF
	IF os.path.extension(l_file) IS NULL THEN CALL invalidArgs("No file extension") END IF
	IF os.path.extension(l_file) != "zip" AND NOT l_gar THEN CALL invalidArgs("Wrong file extension, expected .zip") END IF
	IF os.path.extension(l_file) != "gar" AND l_gar THEN CALL invalidArgs("Wrong file extension, expected .gar") END IF
	IF NOT os.path.exists(l_file) THEN CALL invalidArgs(SFMT("File '%1' not found",l_file)) END IF

	-- get URL / ClientID / Secret
	IF NOT getServerDetails( ARG_VAL(3) ) THEN
		CALL abort()
	END IF

	-- get Token
	IF NOT getToken() THEN
		CALL abort()
	END IF

	CALL OAuthAPI.InitService(m_server.connTimeout, m_server.token) RETURNING l_stat
	IF NOT l_stat THEN
  	LET m_message = "OAuthAPI.InitService Failed!"
		CALL abort()
	ELSE
  	DISPLAY "OAuthAPI.InitService Okay."
	END IF

	-- deploy gar / gbc file
	IF l_gar THEN
		LET gar_api.Endpoint.Address.Uri = m_server.url||C_GAR_ENDPOINT
		CALL garDeploy(l_file)
	ELSE
		LET gbc_api.Endpoint.Address.Uri = m_server.url||C_GBC_ENDPOINT
		CALL gbcDeploy(l_file)
	END IF

END MAIN
--------------------------------------------------------------------------------
FUNCTION invalidArgs(l_msg STRING)
	DISPLAY "Error: ",l_msg
	DISPLAY "Args: \n gar / gbc : To deploy gar file or a gbc zip\n filename : File to deploy \n server config filename : JSON file with server details"
	DISPLAY "Example: fglrun "||base.application.getProgramName()||".42r gbc mygbc.zip local.json"
	EXIT PROGRAM 1
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION abort()
	DISPLAY m_message
	EXIT PROGRAM 1
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getServerDetails(l_file STRING) RETURNS BOOLEAN
	DEFINE l_str TEXT
	IF NOT os.path.exists( l_file ) THEN
		LET m_message = SFMT("json server config file %1 is missing!", l_file)
		RETURN FALSE
	END IF
	LOCATE l_str IN FILE l_file
	TRY
		CALL util.json.parse( l_str, m_server )
	CATCH
		LET m_message = SFMT("Failed to parse json config file %1 !", l_file)
		RETURN FALSE
	END TRY
	DISPLAY SFMT("Server: %1 - %2", m_server.name, m_server.url)
	RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getToken()
  DEFINE l_metadata         OAuthAPI.OpenIDMetadataType
  DEFINE l_scopes_supported STRING
  DEFINE x                  SMALLINT
	DEFINE l_idp STRING

	LET l_idp = m_server.url || "/ws/r/services/GeneroIdentityProvider"

-- Retieve IdP info to get token endpoint for service access
  CALL debug("getToken", "l_idp", l_idp)

  CALL OAuthAPI.FetchOpenIDMetadata(m_server.connTimeout , l_idp) RETURNING l_metadata.*
  IF l_metadata.issuer IS NULL THEN
    LET m_message = SFMT("Error : IDP unavailable: %1", l_idp)
    RETURN FALSE
  END IF

  IF fgl_getEnv("MYWSDEBUG") = "9" THEN
    FOR x = 1 TO l_metadata.scopes_supported.getLength()
      LET l_scopes_supported = l_scopes_supported.append(l_metadata.scopes_supported[x] || " ")
    END FOR
    CALL debug("getToken", "l_metadata.token_endpoint", l_metadata.token_endpoint)
    CALL debug("getToken", "l_scopes_supported", l_scopes_supported)
  END IF

-- Get the access token using token endpoint and clientId/password
  CALL OAuthAPI.RetrieveServiceToken(
          m_server.connTimeout, l_metadata.token_endpoint, m_server.cli_id, m_server.secret, m_server.scopes)
      RETURNING m_server.token, m_server.tokenExpires
  IF m_server.token IS NULL THEN
    LET m_message =
        SFMT("Unable to retrieve token from %1 for %2", l_metadata.token_endpoint, m_server.scopes)
    RETURN FALSE
  ELSE
    DISPLAY "Token received."
  END IF
  CALL debug("getToken", "token", m_server.token)
  CALL debug("getToken", "tokenExpire", m_server.tokenExpires)

	RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION debug(l_func STRING, l_msg STRING, l_data STRING)
	IF fgl_getEnv("DEBUG") = "1" THEN
		DISPLAY CURRENT,":",l_func," - ", l_msg, " ",l_data
	END IF
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION garDeploy(l_file STRING)
	DEFINE l_arc STRING
	DEFINE l_stat SMALLINT
	DEFINE l_reply xml.DomDocument

	LET l_arc = os.path.baseName( l_file )
	LET l_arc = os.path.rootName( l_arc )

	DISPLAY SFMT("Gar Disable %1", l_arc)
	CALL gar_api.DisableArchive( l_arc ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

	DISPLAY SFMT("Gar Undeploy %1", l_arc)
	CALL gar_api.UndeployArchive( l_arc ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

	DISPLAY SFMT("Gar Deploy %1 - %2", l_arc, l_file)
	CALL gar_api.DeployArchive( l_arc, l_file ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

	DISPLAY SFMT("Gar Enable %1", l_arc)
	CALL gar_api.EnableArchive( l_arc ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION gbcDeploy(l_file STRING)
	DEFINE l_arc STRING
	DEFINE l_stat SMALLINT
	DEFINE l_reply xml.DomDocument

	LET l_arc = os.path.baseName( l_file )
	LET l_arc = os.path.rootName( l_arc )

	DISPLAY SFMT("GBC Undeploy %1", l_arc)
	CALL gbc_api.UndeployGBC( l_arc ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

	DISPLAY SFMT("GBC Deploy %1 - %2", l_arc, l_file)
	CALL gbc_api.DeployGBC( l_arc, l_file ) RETURNING l_stat, l_reply
	IF NOT checkResult( l_stat, l_reply ) THEN CALL abort() END IF

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION checkResult( l_stat SMALLINT, l_reply xml.DomDocument ) RETURNS BOOLEAN
	DEFINE l_node xml.DomNode
	DEFINE l_nl xml.DomNodeList
	DEFINE l_msg STRING
	DEFINE x SMALLINT
	IF l_stat != 0 THEN
		LET m_message = SFMT("Error Status: %1 ", l_stat )
	END IF
	IF l_reply IS NULL THEN RETURN FALSE END IF

	LET l_node = l_reply.getFirstDocumentNode()
	LET l_nl = l_node.getElementsByTagName("ERROR")
	FOR x = 1 TO l_nl.getCount()
		LET l_msg = l_nl.getItem(x).getFirstChild().getNodeValue()
		LET m_message = m_message.append( "\n"||l_msg )
	END FOR	
	LET l_nl = l_node.getElementsByTagName("MESSAGE")
	FOR x = 1 TO l_nl.getCount()
		LET l_msg = l_nl.getItem(x).getFirstChild().getNodeValue()
	END FOR	
	DISPLAY l_msg
	RETURN TRUE
END FUNCTION
