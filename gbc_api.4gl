#+
#+ Generated from gbc_api
#+
IMPORT com
IMPORT xml
IMPORT util
IMPORT os
IMPORT FGL OAuthAPI

#+
#+ Global Endpoint user-defined type definition
#+
TYPE tGlobalEndpointType RECORD # Rest Endpoint
	Address RECORD                # Address
		Uri STRING                  # URI
	END RECORD,
	Binding RECORD               # Binding
		Version           STRING,  # HTTP Version (1.0 or 1.1)
		ConnectionTimeout INTEGER, # Connection timeout
		ReadWriteTimeout  INTEGER, # Read write timeout
		CompressRequest   STRING   # Compression (gzip or deflate)
	END RECORD
END RECORD

PUBLIC DEFINE Endpoint tGlobalEndpointType =
		(Address:(Uri: "http://generodemos.dynu.net/z/ws/r/admin/GeneroDeploymentService/gbc"))

# Error codes
PUBLIC CONSTANT C_SUCCESS      = 0
PUBLIC CONSTANT C_GBCERROR     = 1001
PUBLIC CONSTANT C_NO_GBC_FOUND = 1002

# generated RenameGBCResponseBodyType
PUBLIC TYPE RenameGBCResponseBodyType xml.DomDocument

# generated GbcErrorErrorType
PUBLIC TYPE GbcErrorErrorType RECORD
	operation   STRING,
	description STRING
END RECORD

# generated ResetGBCResponseBodyType
PUBLIC TYPE ResetGBCResponseBodyType xml.DomDocument

# generated ListGBCResponseBodyType
PUBLIC TYPE ListGBCResponseBodyType xml.DomDocument

# generated SetDefaultGBCResponseBodyType
PUBLIC TYPE SetDefaultGBCResponseBodyType xml.DomDocument

# generated UndeployGbcResponseBodyType
PUBLIC TYPE UndeployGbcResponseBodyType xml.DomDocument

# generated DeployGBCResponseBodyType
PUBLIC TYPE DeployGBCResponseBodyType xml.DomDocument

PUBLIC # GBC error
		DEFINE GbcError GbcErrorErrorType

################################################################################
# Operation /rename
#
# VERB: GET
# ID:          RenameGBC
# DESCRIPTION: Rename GBC
#
PUBLIC FUNCTION RenameGBC(p_archive STRING) RETURNS(INTEGER, RenameGBCResponseBodyType)
	DEFINE fullpath                   base.StringBuffer
	DEFINE query                      base.StringBuffer
	DEFINE contentType                STRING
	DEFINE req                        com.HTTPRequest
	DEFINE resp                       com.HTTPResponse
	DEFINE resp_body                  RenameGBCResponseBodyType
	DEFINE xml_resp_body              xml.DomDocument
	DEFINE xml_body                   xml.DomDocument
	DEFINE xml_node                   xml.DomNode
	DEFINE json_body                  STRING
	DEFINE txt                        STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/rename")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF query.getLength() > 0 THEN
			CALL fullpath.append("?")
			CALL fullpath.append(query.toString())
		END IF

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("GET")
			CALL req.setHeader("Accept", "application/xml, application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /reset
#
# VERB: GET
# ID:          ResetGBC
# DESCRIPTION: Reset to installed GBC
#
PUBLIC FUNCTION ResetGBC() RETURNS(INTEGER, ResetGBCResponseBodyType)
	DEFINE fullpath      base.StringBuffer
	DEFINE contentType   STRING
	DEFINE req           com.HTTPRequest
	DEFINE resp          com.HTTPResponse
	DEFINE resp_body     ResetGBCResponseBodyType
	DEFINE xml_resp_body xml.DomDocument
	DEFINE xml_body      xml.DomDocument
	DEFINE xml_node      xml.DomNode
	DEFINE json_body     STRING
	DEFINE txt           STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		CALL fullpath.append("/reset")

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("GET")
			CALL req.setHeader("Accept", "application/xml, application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /list
#
# VERB: GET
# ID:          ListGBC
# DESCRIPTION: Return the list of installed GBC
#
PUBLIC FUNCTION ListGBC() RETURNS(INTEGER, ListGBCResponseBodyType)
	DEFINE fullpath      base.StringBuffer
	DEFINE contentType   STRING
	DEFINE req           com.HTTPRequest
	DEFINE resp          com.HTTPResponse
	DEFINE resp_body     ListGBCResponseBodyType
	DEFINE xml_resp_body xml.DomDocument
	DEFINE xml_body      xml.DomDocument
	DEFINE xml_node      xml.DomNode
	DEFINE json_body     STRING
	DEFINE txt           STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		CALL fullpath.append("/list")

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("GET")
			CALL req.setHeader("Accept", "application/xml, application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /default
#
# VERB: GET
# ID:          SetDefaultGBC
# DESCRIPTION: Set as default GBC
#
PUBLIC FUNCTION SetDefaultGBC(p_archive STRING) RETURNS(INTEGER, SetDefaultGBCResponseBodyType)
	DEFINE fullpath                       base.StringBuffer
	DEFINE query                          base.StringBuffer
	DEFINE contentType                    STRING
	DEFINE req                            com.HTTPRequest
	DEFINE resp                           com.HTTPResponse
	DEFINE resp_body                      SetDefaultGBCResponseBodyType
	DEFINE xml_resp_body                  xml.DomDocument
	DEFINE xml_body                       xml.DomDocument
	DEFINE xml_node                       xml.DomNode
	DEFINE json_body                      STRING
	DEFINE txt                            STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/default")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF query.getLength() > 0 THEN
			CALL fullpath.append("?")
			CALL fullpath.append(query.toString())
		END IF

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("GET")
			CALL req.setHeader("Accept", "application/xml, application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /undeploy
#
# VERB: GET
# ID:          UndeployGbc
# DESCRIPTION: undeploy Genero Browser Client
#
PUBLIC FUNCTION UndeployGbc(p_archive STRING) RETURNS(INTEGER, UndeployGbcResponseBodyType)
	DEFINE fullpath                     base.StringBuffer
	DEFINE query                        base.StringBuffer
	DEFINE contentType                  STRING
	DEFINE req                          com.HTTPRequest
	DEFINE resp                         com.HTTPResponse
	DEFINE resp_body                    UndeployGbcResponseBodyType
	DEFINE xml_resp_body                xml.DomDocument
	DEFINE xml_body                     xml.DomDocument
	DEFINE xml_node                     xml.DomNode
	DEFINE json_body                    STRING
	DEFINE txt                          STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/undeploy")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF query.getLength() > 0 THEN
			CALL fullpath.append("?")
			CALL fullpath.append(query.toString())
		END IF

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("GET")
			CALL req.setHeader("Accept", "application/xml, application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /deploy
#
# VERB: POST
# ID:          DeployGBC
# DESCRIPTION: Deploy a new GBC
#
PUBLIC FUNCTION DeployGBC(p_archive STRING, p_body STRING) RETURNS(INTEGER, DeployGBCResponseBodyType)
	DEFINE fullpath                   base.StringBuffer
	DEFINE query                      base.StringBuffer
	DEFINE contentType                STRING
	DEFINE req                        com.HTTPRequest
	DEFINE resp                       com.HTTPResponse
	DEFINE resp_body                  DeployGBCResponseBodyType
	DEFINE xml_resp_body              xml.DomDocument
	DEFINE xml_body                   xml.DomDocument
	DEFINE xml_node                   xml.DomNode
	DEFINE json_body                  STRING
	DEFINE txt                        STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/deploy")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF query.getLength() > 0 THEN
			CALL fullpath.append("?")
			CALL fullpath.append(query.toString())
		END IF

		WHILE TRUE
			# Create oauth request and configure it
			LET req = OAuthAPI.CreateHTTPAuthorizationRequest(SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
			IF Endpoint.Binding.Version IS NOT NULL THEN
				CALL req.setVersion(Endpoint.Binding.Version)
			END IF
			IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
				CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
			END IF
			IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
				CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
			END IF
			IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
				CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
			END IF

			# Perform request
			CALL req.setMethod("POST")
			CALL req.setHeader("Accept", "application/xml, application/json")
			# Perform FILE request
			CALL req.DoFileRequest(p_body)

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		INITIALIZE resp_body TO NULL
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 200 #Success
				IF contentType MATCHES "*application/xml*" THEN
					# Parse XML response
					LET xml_resp_body = resp.getXmlResponse()
					LET resp_body     = xml_resp_body
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #GBC error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GbcError)
					RETURN C_GBCERROR, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 404 #no gbc found
				RETURN C_NO_GBC_FOUND, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################
