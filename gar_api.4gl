#+
#+ Generated from gar_openapi
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
		(Address:(Uri: "http://generodemos.dynu.net/z/ws/r/admin/GeneroDeploymentService/gar"))

# Error codes
PUBLIC CONSTANT C_SUCCESS           = 0
PUBLIC CONSTANT C_GARERROR          = 1001
PUBLIC CONSTANT C_ARCHIVE_NOT_FOUND = 1002
PUBLIC CONSTANT C_FILE_NOT_FOUND    = 1003
PUBLIC CONSTANT C_GARERROR_DUP      = 1004

# generated SecureArchiveResponseBodyType
PUBLIC TYPE SecureArchiveResponseBodyType DYNAMIC ARRAY OF RECORD
	xcf     STRING,
	kind    STRING,
	err_msg STRING
END RECORD

# generated GarErrorErrorType
PUBLIC TYPE GarErrorErrorType RECORD
	operation   STRING,
	description STRING
END RECORD

# generated UnsecureArchiveResponseBodyType
PUBLIC TYPE UnsecureArchiveResponseBodyType DYNAMIC ARRAY OF RECORD
	xcf     STRING,
	kind    STRING,
	err_msg STRING
END RECORD

# generated FetchDelegateResponseBodyType
PUBLIC TYPE FetchDelegateResponseBodyType RECORD
	delegate  BOOLEAN,
	client_id STRING
END RECORD

# generated ListArchiveResponseBodyType
PUBLIC TYPE ListArchiveResponseBodyType xml.DomDocument

# generated DisableArchiveResponseBodyType
PUBLIC TYPE DisableArchiveResponseBodyType xml.DomDocument

# generated EnableArchiveResponseBodyType
PUBLIC TYPE EnableArchiveResponseBodyType xml.DomDocument

# generated UndeployArchiveResponseBodyType
PUBLIC TYPE UndeployArchiveResponseBodyType xml.DomDocument

# generated DeployArchiveResponseBodyType
PUBLIC TYPE DeployArchiveResponseBodyType xml.DomDocument

PUBLIC # Gar deployment error
		DEFINE GarError GarErrorErrorType

################################################################################
# Operation /secure
#
# VERB: GET
# ID:          SecureArchive
# DESCRIPTION: Secure the entire archive
#
PUBLIC FUNCTION SecureArchive(p_archive STRING) RETURNS(INTEGER, SecureArchiveResponseBodyType)
	DEFINE fullpath                       base.StringBuffer
	DEFINE query                          base.StringBuffer
	DEFINE contentType                    STRING
	DEFINE req                            com.HTTPRequest
	DEFINE resp                           com.HTTPResponse
	DEFINE resp_body                      SecureArchiveResponseBodyType
	DEFINE json_body                      STRING
	DEFINE txt                            STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/secure")
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
			CALL req.setHeader("Accept", "application/json")
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
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, resp_body)
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
#
# VERB: DELETE
# ID:          UnsecureArchive
# DESCRIPTION: Unsecure the entire archive
#
PUBLIC FUNCTION UnsecureArchive(p_archive STRING) RETURNS(INTEGER, UnsecureArchiveResponseBodyType)
	DEFINE fullpath                         base.StringBuffer
	DEFINE query                            base.StringBuffer
	DEFINE contentType                      STRING
	DEFINE req                              com.HTTPRequest
	DEFINE resp                             com.HTTPResponse
	DEFINE resp_body                        UnsecureArchiveResponseBodyType
	DEFINE json_body                        STRING
	DEFINE txt                              STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/secure")
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
			CALL req.setMethod("DELETE")
			CALL req.setHeader("Accept", "application/json")
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
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, resp_body)
					RETURN C_SUCCESS, resp_body
				END IF
				RETURN -1, resp_body

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /delegate
#
# VERB: GET
# ID:          FetchDelegate
# DESCRIPTION: Returns archive delegate for given xcf
#
PUBLIC FUNCTION FetchDelegate(p_archive STRING, p_xcf STRING) RETURNS(INTEGER, FetchDelegateResponseBodyType)
	DEFINE fullpath                       base.StringBuffer
	DEFINE query                          base.StringBuffer
	DEFINE contentType                    STRING
	DEFINE req                            com.HTTPRequest
	DEFINE resp                           com.HTTPResponse
	DEFINE resp_body                      FetchDelegateResponseBodyType
	DEFINE json_body                      STRING
	DEFINE txt                            STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/delegate")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF p_xcf IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&xcf=%1", p_xcf))
			ELSE
				CALL query.append(SFMT("xcf=%1", p_xcf))
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
			CALL req.setHeader("Accept", "application/json")
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
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, resp_body)
					RETURN C_SUCCESS, resp_body.*
				END IF
				RETURN -1, resp_body.*

			WHEN 404 #archive not found
				RETURN C_ARCHIVE_NOT_FOUND, resp_body.*

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body.*
		END CASE
	CATCH
		RETURN -1, resp_body.*
	END TRY
END FUNCTION
#
# VERB: DELETE
# ID:          DeleteDelegate
# DESCRIPTION: Delete the delegate to given xcf of given archive
#
PUBLIC FUNCTION DeleteDelegate(p_archive STRING, p_xcf STRING) RETURNS(INTEGER)
	DEFINE fullpath                        base.StringBuffer
	DEFINE query                           base.StringBuffer
	DEFINE contentType                     STRING
	DEFINE req                             com.HTTPRequest
	DEFINE resp                            com.HTTPResponse
	DEFINE json_body                       STRING
	DEFINE txt                             STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/delegate")
		IF p_archive IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&archive=%1", p_archive))
			ELSE
				CALL query.append(SFMT("archive=%1", p_archive))
			END IF
		END IF
		IF p_xcf IS NOT NULL THEN
			IF query.getLength() > 0 THEN
				CALL query.append(SFMT("&xcf=%1", p_xcf))
			ELSE
				CALL query.append(SFMT("xcf=%1", p_xcf))
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
			CALL req.setMethod("DELETE")
			CALL req.setHeader("Accept", "application/json")
			CALL req.DoRequest()

			# Retrieve response
			LET resp = req.getResponse()
			# Retry if access token has expired
			IF NOT OAuthAPI.RetryHTTPRequest(resp) THEN
				EXIT WHILE
			END IF
		END WHILE
		# Process response
		LET contentType = resp.getHeader("Content-Type")
		CASE resp.getStatusCode()

			WHEN 204 #No Content
				RETURN C_SUCCESS

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR
				END IF
				RETURN -1

			WHEN 404 #file not found
				RETURN C_FILE_NOT_FOUND

			OTHERWISE
				RETURN resp.getStatusCode()
		END CASE
	CATCH
		RETURN -1
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /list
#
# VERB: GET
# ID:          ListArchive
# DESCRIPTION: Returns the list of deployed archives
#
PUBLIC FUNCTION ListArchive() RETURNS(INTEGER, ListArchiveResponseBodyType)
	DEFINE fullpath      base.StringBuffer
	DEFINE contentType   STRING
	DEFINE req           com.HTTPRequest
	DEFINE resp          com.HTTPResponse
	DEFINE resp_body     ListArchiveResponseBodyType
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

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /disable
#
# VERB: GET
# ID:          DisableArchive
# DESCRIPTION: Disable given archive
#
PUBLIC FUNCTION DisableArchive(p_archive STRING) RETURNS(INTEGER, DisableArchiveResponseBodyType)
	DEFINE fullpath                        base.StringBuffer
	DEFINE query                           base.StringBuffer
	DEFINE contentType                     STRING
	DEFINE req                             com.HTTPRequest
	DEFINE resp                            com.HTTPResponse
	DEFINE resp_body                       DisableArchiveResponseBodyType
	DEFINE xml_resp_body                   xml.DomDocument
	DEFINE xml_body                        xml.DomDocument
	DEFINE xml_node                        xml.DomNode
	DEFINE txt                             STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/disable")
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
			CALL req.setHeader("Accept", "application/xml")
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

			WHEN 400 #GarError
				RETURN C_GARERROR_DUP, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /enable
#
# VERB: GET
# ID:          EnableArchive
# DESCRIPTION: Enable deployed archive
#
PUBLIC FUNCTION EnableArchive(p_archive STRING) RETURNS(INTEGER, EnableArchiveResponseBodyType)
	DEFINE fullpath                       base.StringBuffer
	DEFINE query                          base.StringBuffer
	DEFINE contentType                    STRING
	DEFINE req                            com.HTTPRequest
	DEFINE resp                           com.HTTPResponse
	DEFINE resp_body                      EnableArchiveResponseBodyType
	DEFINE xml_resp_body                  xml.DomDocument
	DEFINE xml_body                       xml.DomDocument
	DEFINE xml_node                       xml.DomNode
	DEFINE json_body                      STRING
	DEFINE txt                            STRING

	TRY

		# Prepare request path
		LET fullpath = base.StringBuffer.Create()
		LET query    = base.StringBuffer.Create()
		CALL fullpath.append("/enable")
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

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

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
# ID:          UndeployArchive
# DESCRIPTION: Undeploy archive
#
PUBLIC FUNCTION UndeployArchive(p_archive STRING) RETURNS(INTEGER, UndeployArchiveResponseBodyType)
	DEFINE fullpath                         base.StringBuffer
	DEFINE query                            base.StringBuffer
	DEFINE contentType                      STRING
	DEFINE req                              com.HTTPRequest
	DEFINE resp                             com.HTTPResponse
	DEFINE resp_body                        UndeployArchiveResponseBodyType
	DEFINE xml_resp_body                    xml.DomDocument
	DEFINE xml_body                         xml.DomDocument
	DEFINE xml_node                         xml.DomNode
	DEFINE json_body                        STRING
	DEFINE txt                              STRING

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

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

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
# ID:          DeployArchive
# DESCRIPTION: Deploy archive
#
PUBLIC FUNCTION DeployArchive(p_archive STRING, p_body STRING) RETURNS(INTEGER, DeployArchiveResponseBodyType)
	DEFINE fullpath                       base.StringBuffer
	DEFINE query                          base.StringBuffer
	DEFINE contentType                    STRING
	DEFINE req                            com.HTTPRequest
	DEFINE resp                           com.HTTPResponse
	DEFINE resp_body                      DeployArchiveResponseBodyType
	DEFINE xml_resp_body                  xml.DomDocument
	DEFINE xml_body                       xml.DomDocument
	DEFINE xml_node                       xml.DomNode
	DEFINE json_body                      STRING
	DEFINE txt                            STRING

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

			WHEN 400 #Gar deployment error
				IF contentType MATCHES "*application/json*" THEN
					# Parse JSON response
					LET json_body = resp.getTextResponse()
					CALL util.JSON.parse(json_body, GarError)
					RETURN C_GARERROR, resp_body
				END IF
				RETURN -1, resp_body

			OTHERWISE
				RETURN resp.getStatusCode(), resp_body
		END CASE
	CATCH
		RETURN -1, resp_body
	END TRY
END FUNCTION
################################################################################
