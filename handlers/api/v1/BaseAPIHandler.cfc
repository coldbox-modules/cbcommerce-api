/**
 * @name Base API Handler
 * @description This is the base handler for the v1 cbCommerce API
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="coldbox.system.EventHandler"{
    property name="resultsMapper" inject="ResultsMapper@mementifier";
	// Pseudo "constants" used in API Response/Method parsing
	property name="METHODS";
	property name="STATUS";

	// Verb aliases - in case we are dealing with legacy browsers or servers ( e.g. IIS7 default )
	METHODS = {
		"HEAD" 		: "HEAD",
		"GET" 		: "GET",
		"POST" 		: "POST",
		"PATCH" 	: "PATCH",
		"PUT" 		: "PUT",
		"DELETE" 	: "DELETE"
	};

	// HTTP STATUS CODES
	STATUS = {
		"CREATED" 				: 201,
		"ACCEPTED" 				: 202,
		"SUCCESS" 				: 200,
		"NO_CONTENT" 			: 204,
		"RESET" 				: 205,
		"PARTIAL_CONTENT" 		: 206,
		"BAD_REQUEST" 			: 400,
		"NOT_AUTHORIZED" 		: 403,
		"NOT_AUTHENTICATED" 	: 401,
		"NOT_FOUND" 			: 404,
		"NOT_ALLOWED" 			: 405,
		"NOT_ACCEPTABLE" 		: 406,
		"TOO_MANY_REQUESTS" 	: 429,
		"EXPECTATION_FAILED" 	: 417,
		"INTERNAL_ERROR" 		: 500,
		"NOT_IMPLEMENTED" 		: 501
	};

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 		= "";
	this.prehandler_except 		= "";
	this.posthandler_only 		= "";
	this.posthandler_except 	= "";
	this.aroundHandler_only 	= "";
	this.aroundHandler_except 	= "";

	// Abstracted index method
	function index( event, rc, prc ){
		var searchResponse = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		prc.response.setData(
			resultsMapper.process(
				collection = searchResponse.collection,
				includes=rc.includes,
				profile=rc.profile,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setPagination(
			searchResponse.pagination
		);
	}

	/**
	* Around handler for all actions it inherits
	*/
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){

		event.paramValue( "currency", "USD" );
		event.paramValue( "maxrows", 10 );
		event.paramValue( "offset", 0 );
		event.paramValue( "sortOrder", "createdTime DESC" );
		event.paramValue( "includes", "" );
		event.paramValue( "excludes", "" );

		if( structKeyExists( this, "API_BASE_URL" ) ){
			rc.includes = listAppend( rc.includes, "href" );
		}

		//options includes
		event.paramValue( "returnOptions", "" );

		if( event.valueExists( "page" ) ){
			rc.offset = rc.page == 1 ? 0 : ( rc.page - 1 ) * rc.maxrows;
		} else {
			event.paramValue( "page", 1 );
		}

		try{
			// start a resource timer
			var stime = getTickCount();


			//handle any content payloads
			// If the inbound content body is a JSON payload capture it
			if(
				len( event.getHTTPContent() )
				&& isJSON(  event.getHTTPContent() )
				&& isStruct( event.getHTTPContent( json=true ) )
			) {
				structAppend( rc, event.getHTTPContent( json=true ) );
			}

			// prepare our response object
			prc.response = getInstance( "APIResponse@cbCommerce" );

			prc.response.addHeader(
				"Access-Control-Expose-Headers",
				"x-csrf-token"
			).addHeader(
				"x-csrf-token",
				csrfToken()
			);

			// prepare argument execution
			var args = {
				event = arguments.event,
				rc = arguments.rc,
				prc = arguments.prc,
				// add for framework error events which fire the aroundHandler()
				faultAction = arguments.faultAction ?: javacast( "null", 0 ),
				exception = arguments.exception ?: javacast( "null", 0 )
			};
			structAppend( args, arguments.eventArguments );
			// Incoming Format Detection
			if( structKeyExists( rc, "format") ){
				prc.response.setFormat( rc.format );
			}
			// Execute action
			var actionResults = arguments.targetAction( argumentCollection=args );
		} catch( MissingPricingException e ){
			prc.response.setError( true )
						.addMessage( e.message )
						.setStatusText( "Expectation Failed" )
						.setStatusCode( STATUS.EXPECTATION_FAILED );
		} catch ( EntityNotFoundException e ) {
			prc.response.addMessage( e.message );
			routeNotfound( event, rc, prc );
		} catch ( EntityValidationException e ) {
			prc.response.setError( true );
			prc.response.setStatusCode( STATUS.NOT_ACCEPTABLE );
			prc.response.addMessage( deserializeJSON( e.message ) );
		} catch ( AuthorizationException e ) {
			prc.response.setError( true );
			prc.response.setStatusCode( STATUS.NOT_AUTHORIZED );
			prc.response.addMessage( e.message );
		} catch( Any e ){
			log.error( "Error calling #event.getCurrentEvent()#: #e.message# #e.detail#", e.stackTrace );

			// Setup General Error Response
			prc.response
				.setData( {} )
				.setError( true )
				.addHeader( "x-error", e.message )
				.addMessage( "General application error: #e.message#" )
				.setStatusCode( STATUS.INTERNAL_ERROR )
				.setStatusText( "General application error" );

			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				prc.response.addMessage( "Detail: #e.detail#" )
					.addMessage( "StackTrace: #e.stacktrace#" );
			}

		}

		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addHeader( "x-current-route", event.getCurrentRoute() )
				.addHeader( "x-current-routed-url", event.getCurrentRoutedURL() )
				.addHeader( "x-current-routed-namespace", event.getCurrentRoutedNamespace() )
				.addHeader( "x-current-event", event.getCurrentEvent() );
		}
		// end timer
		prc.response.setResponseTime( getTickCount() - stime );

		// If results detected, just return them, controllers requesting to return results
		if( !isNull( actionResults ) ){
			return actionResults;
		}

		// Verify if controllers doing renderdata overrides? If so, just short-circuit out.
		if( !structIsEmpty( event.getRenderData() ) ){
			return;
		}

		// Get response data
		var responseData = prc.response.getDataPacket();
		// If we have an error flag, render our messages and omit any marshalled data
		if( prc.response.getError() ){
			responseData = prc.response.getDataPacket( reset=true );
		}

		// Did the controllers set a view to be rendered? If not use renderdata, else just delegate to view.
		if( !len( event.getCurrentView() ) ){

			// Magical Response renderings
			event.renderData(
				type		= prc.response.getFormat(),
				data 		= !responseData.error ? responseData.data : responseData,
				contentType = prc.response.getContentType(),
				statusCode 	= prc.response.getStatusCode(),
				statusText 	= prc.response.getStatusText(),
				location 	= prc.response.getLocation(),
				isBinary 	= prc.response.getBinary()
			);
		}

		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );

		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/**
	* on localized errors
	*/
	function onError( event, rc, prc, faultAction, exception ){

		if( !structKeyExists( arguments, "exception" ) ){
			prc.response
				.setData( {} )
				.setError( true )
				.addMessage( "An fatal error occurred.  No Additional information was available." )
				.setStatusCode( STATUS.INTERNAL_ERROR )
				.setStatusText( "General application error" );

		} else {

			// Log Locally
			log.error( "Error in base handler (#arguments.faultAction#): #arguments.exception.message# #arguments.exception.detail#", arguments.exception );

			// Verify response exists, else create one
			if( !structKeyExists( prc, "response" ) ){
				prc.response = getInstance( "APIResponse@cbCommerce" );
			}

			// Setup General Error Response
			prc.response
				.setData( {} )
				.setError( true )
				.addMessage( "Base Handler Application Error: #arguments.exception.message#" )
				.setStatusCode( STATUS.INTERNAL_ERROR )
				.setStatusText( "General application error" );

			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				prc.response.addMessage( "Detail: #arguments.exception.detail#" )
					.addMessage( "StackTrace: #arguments.exception.stacktrace#" );
			}

		}

		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
		// Log Locally
		log.warn( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getInstance( "APIResponse@cbCommerce" )
			.setError( true )
			.addMessage( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid HTTP Method" );
		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* Invalid method execution
	**/
	function onMissingAction( event, rc, prc, missingAction, eventArguments ){
		// Log Locally
		log.warn( "Invalid HTTP Method Execution of (#arguments.missingAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getInstance( "APIResponse@cbCommerce" )
			.setError( true )
			.addMessage( "Action '#arguments.missingAction#' could not be found" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid Action" );
		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**************************** RESTFUL UTILITIES ************************/

	/**
	* Utility function for miscellaneous 404's
	**/
	function routeNotFound( event, rc, prc ){

		if( !structKeyExists( prc, "response" ) ){
			prc.response = getInstance( "APIResponse@cbCommerce" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_FOUND )
			.setStatusText( "Not Found" )
			.addMessage( "The object requested could not be found" );
	}

	/**
	* Utility method for when an expectation of the request failes ( e.g. an expected paramter is not provided )
	**/
	public function onExpectationFailed(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true )
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getInstance( "APIResponse@cbCommerce" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.EXPECTATION_FAILED )
			.setStatusText( "Expectation Failed" )
			.addMessage( "An expectation for the request failed. Could not proceed" );
	}

	/**
	* Utility method to render missing or invalid authentication credentials
	**/
	public function onAuthenticationFailure(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true ),
		abort 	= false
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getInstance( "APIResponse@cbCommerce" );
		}

		log.warn( "Invalid Authentication", getHTTPRequestData() );

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_AUTHENTICATED )
			.setStatusText( "Invalid or Missing Credentials" )
			.addMessage( "Invalid or Missing Authentication Credentials" );
	}

	/**
	* Utility method to render a failure of authorization on any resource
	**/
	public function onAuthorizationFailure(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true ),
		abort 	= false
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getInstance( "APIResponse@cbCommerce" );
		}

		log.warn( "Authorization Failure", getHTTPRequestData() );

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_AUTHORIZED )
			.setStatusText( "Unauthorized Resource" )
			.addMessage( "Your permissions do not allow this operation" );

		/**
		* When you need a really hard stop to prevent further execution ( use as last resort )
		**/
		if( arguments.abort ){

			event.setHTTPHeader(
				name 	= "Content-Type",
	        	value 	= "application/json"
			);

			event.setHTTPHeader(
				statusCode = "#STATUS.NOT_AUTHORIZED#",
	        	statusText = "Not Authorized"
			);

			writeOutput(
				serializeJSON( prc.response.getDataPacket( reset=true ) )
			);
			flush;
			abort;
		}
	}


	/**
	 * Validates a model and throws a custom exception if validation fails
	 *
	 * @model  The model to validate
	 */
	public function validateModelOrFail( model ) {

		var validationResults = validateModel( model );

        if ( validationResults.hasErrors() ) {
            var messages = validationResults.getAllErrors();
            arrayPrepend( messages, "The #getMetadata( model ).name# failed to pass validation.  Please try again." );
            throw(
                type = "EntityValidationException",
                message = serializeJSON( messages )
            );
        }
        return this;
    }

	function hrefMapper( item, memento ){
		return this.APIBaseURL & "/" & memento.id;
	}

}