component extends="BaseTest"{

    property name="saveResponses" default="false";

    //HTTP STATUS CODES
    variables.STATUS = {
        "CREATED":201,
        "ACCEPTED":202,
        "SUCCESS":200,
        "NO_CONTENT":204,
        "RESET":205,
        "PARTIAL_CONTENT":206,
        "BAD_REQUEST":400,
        "NOT_AUTHENTICATED":401,
        "NOT_AUTHORIZED":403,
        "NOT_FOUND":404,
        "NOT_ALLOWED":405,
        "NOT_ACCEPTABLE":406,
        "TOO_MANY_REQUESTS":429,
        "EXPECTATION_FAILED":417,
        "INTERNAL_ERROR":500,
        "NOT_IMPLEMENTED":501
    };

	function newEventArgs( method = "GET", struct payload = {} ) {

        //clear out all request keys
        for( var key in request ){
            if( findNoCase( "wirebox:", key ) ){
                structDelete( REQUEST, key );
            }
        }

        setup();

        var event = getRequestContext();
        prepareMock( event )
            .$( "getHTTPMethod", arguments.method )
            .$( method = "getHTTPHeader", callback = function( string name ) {
                if ( arguments.name == "X-Requested-With" ){
                    return "XMLHttpRequest";
                }
                return "";
            } );

        var rc = event.getCollection();
        var prc = event.getCollection( private=true );

        if ( !isNull( arguments.payload ) ){
            structAppend( rc, payload, true );
        }

        event.paramValue( "includes", "" );
        event.paramValue( "isActive", true );
        event.paramValue( "maxrows", 1 );
        event.setPrivateValue( "isTesting", true );

        prc.response = getWirebox().getInstance( "APIResponse@cbCommerce" );

        return {
            "event":event,
            "rc":rc,
            "prc":prc
        };
    }


    /**
    * Generic test for a consistent API response
    * @event 	RequestContext 		The request context returned from event execution
    * @statusCode 	numeric			The numeric status code expected
    **/
    function expectConsistentEventResponse(
        required RequestContext event,
        statusCode=200
    ){
        try {
            var rc = event.getCollection();
            expect( rc ).toBeStruct();
            var prc = event.getCollection( private=true );
            expect( prc ).toBeStruct();

            expect( prc ).toHaveKey( "response" );

            if ( prc.response.getStatusCode() != arguments.statusCode ){
                debug( prc.response.getDataPacket() );
            }
            expect( prc.response.getStatusCode() ).toBe( arguments.statusCode, "Event response did not return the proper status code" );

            var dataPacket = prc.response.getDataPacket();
            expect( dataPacket ).toBeStruct();
            expect( dataPacket ).toHaveKey("data");
            expect( dataPacket ).toHaveKey("error");
            expect( dataPacket.error ).toBeBoolean();
            expect( dataPacket ).toHaveKey( "messages" );
            expect( dataPacket.messages ).toBeArray();

            if( variables.saveResponses ){
                var savedResponsesPath = expandPath( '/modules/cbCommerce/resources/apidocs/examples/tmp' );
                if( !directoryExists( savedResponsesPath ) ){
                    directoryCreate( savedResponsesPath );
                }

                var fileName = arguments.event.getCurrentHandler() & "." & arguments.event.getCurrentAction() & ".json";

                if( structKeyExists( rc, "cbox_rendered_content" ) ){
                    if( fileExists( savedResponsesPath & "/" & fileName ) ){
                        fileDelete( savedResponsesPath & "/" & fileName );
                    }
                    fileWrite( savedResponsesPath & "/" & fileName, rc.cbox_rendered_content );
                }
            }
        }
        catch ( any e ) {
            debug( var = prc.response, top = 3 );
            rethrow;
        }
    }


    /**
    * Makes an API Call using an HTTP request
    * @url  		the endpoint URL to test
    * @type 		the HTTP Method
    * @data 		a struct containing any event params or post data
    * @headers 		a struct containing the headers to be provided in the request
    * @files 		a struct containing any file upload fields to be provided to the endpoint
    **/
    private any function executeHTTPRequest(
        required string url,
        required string type        = "GET",
        required struct data        = {},
        required struct headers     = {},
        required struct files       = {},
        numeric serverPort			= 80

    ) {


        var baseURI = listFirst( CGI.SERVER_PROTOCOL, "/" ) & "://" & CGI.LOCAL_ADDR;
        if( serverPort != 80 ){
            baseURI &= ":" & serverPort;
        }

        //append proxy to base route
        baseURI &= "/tests/HTTPProxy.cfm?route=";

        var h = new Http(
            url    = baseURI & arguments.url,
            method = arguments.type
        );

        if( structIsEmpty( arguments.files) ){

            if( !structIsEmpty( arguments.data ) ) {
                h.addParam( type="BODY", value=serializeJSON( arguments.data ) );
            }

            h.addParam( type="header", name="Content-Type", value="application/json" );

        } else {

            for( var formKey in arguments.data ){
                h.addParam( type="formfield", name=formKey, value=arguments.data[ formKey ] );
            }

            for( var fileField in arguments.files  ){
                h.addParam( type="file", name=fileField, file=arguments.files[ fileField ] );
            }

        }

        for( var headerName in headers ){
            h.addParam( type="header", name=headerName, value=headers[ headerName ] );
        }

        var response = h.send().getPrefix();

        return response;
    }

    /**
    * Verifies a consistent HTTP response from api tests which use cfhttp
    * @cfhttpResponse 	the cfttp request response
    * @statusCode 		the status code expected within the response
    * @statusTest 		an optional status text message to verify
    **/
    function expectConsistentHTTPResponse(
        required cfhttpResponse,
        statusCode = 200,
        statusText
    ){
        try {
            expect( cfhttpResponse ).toBeStruct();
            expect( cfhttpResponse ).toHaveKey( "filecontent" );
            expect( cfhttpResponse ).toHaveKey( "statuscode" );

            if( cfhttpResponse.statuscode != arguments.statusCode || !isJSON( cfhttpResponse.filecontent ) ){
                debug( cfhttpResponse );
                print( cfhttpResponse.fileContent );
            }

            expect( isJSON( cfhttpResponse.fileContent ) ).toBeTrue( "The returned file content was not of type: JSON" );

            expect( cfhttpResponse.statuscode ).toBe( arguments.statusCode );

            if( !isNull( arguments.statusText ) ){
                expect( cfhttpResponse.status_text ).toBe( arguments.statusText );
            }

            if( variables.saveResponses ){
                var savedResponsesPath = expandPath( '/root/includes/tmp/apiOutput' );

                if( !directoryExists( savedResponsesPath ) ){
                    directoryCreate( savedResponsesPath );
                }


                var fileName = arguments.statusCode & "." & arrayToList( listToArray( cfhttpReponse.responseHeader[ "x-current-event" ], "/" ), "." ) & "." & ".json";

                fileWrite( savedResponsesPath & "/" & fileName, response.filecontent );
            }


            var responsePayload = deserializeJSON( cfhttpResponse.filecontent );

            return responsePayload;
        }
        catch ( any e ) {
            debug( var = cfhttpResponse, top = 2 );
            rethrow;
        }


    }

    /**
     * Test helper method to ensure the given user is already authenticated.
     * If they're not authenticated, authenticate them.
     *
     * @username Username of the user to log in or confirm they are already logged in.
     */
    function ensureAuthenticatedUser( required string username ){
        if (
            !authService.check()
            || !securityService.getAuthorizedUser().getUsername() == arguments.username
        ){
            securityService.processLoginSuccess( userService.findByUsername( arguments.username ), "basic", "testing!" );

            expect( authService.check() )
                .toBeTrue( "User should be logged in." );
        }
        return securityService.getAuthorizedUser();
    }

    /**
    * Ensures that a given HTTP method and route are guarded by a specific permission
    *
    * @method HTTP method
    * @event ColdBox event - NOT the url "route", the `module:handler.action` event.
    * @permission Permission name
    */
    function expectGuarded(
        string method,
        string event,
        string permission = "cbCommerce:Administer"
    ){
        var user = ensureAuthenticatedUser( "" );
        expect( user.hasPermission( arguments.permission ) ).toBeFalse();
        var result = execute(
            event         = arguments.event,
            eventArgs     = newEventArgs( arguments.method ),
            renderResults = variables.saveResponses
        );
        expectConsistentEventResponse( result, STATUS.NOT_AUTHORIZED );
    }

	function ensureCustomerOrder( customer ){
		var order = getInstance( "Order@cbCommerce" ).where( "FK_user", customer.getId() ).first();
		if( isNull( order ) ){
			var shippingAddress = getInstance( "CustomerAddress@cbCommerce" )
								.where( "designation", "shipping" )
								.where( "FK_user", customer.getId() )
								.first();
			var billingAddress = getInstance( "CustomerAddress@cbCommerce" )
									.where( "designation", "billing" )
									.where( "FK_user", customer.getId() )
									.first();
			if( isNull( shippingAddress ) ){
				shippingAddress = getInstance( "CustomerAddress@cbcommerce" )
									.fill({
										"FK_user" : customer.getId(),
										"fullName" : customer.getFullName(),
										"address1" : "123 Anywhere Lane",
										"city" : "Grand Rapids",
										"province" : "MI",
										"postalCode" : "49546",
										"country" : "USA",
										"isPrimary" : false,
										"designation" : "shipping"
									}).save().refresh();
			}
			if( isNull( billingAddress ) ){
				billingAddress = getInstance( "CustomerAddress@cbcommerce" )
										.fill({
											"FK_user" : customer.getId(),
											"fullName" : customer.getFullName(),
											"address1" : "123 Anywhere Lane",
											"city" : "Grand Rapids",
											"province" : "MI",
											"postalCode" : "49546",
											"country" : "USA",
											"isPrimary" : false,
											"designation" : "shipping"
										}).save().refresh();
			}
			var order = getInstance( "Order@cbCommerce" ).create( {
				"FK_user" : customer.getId(),
				"subtotal" : 10,
				"shipping" : 10,
				"fees" : 0,
				"tax" : .60,
				"discount" : 0,
				"total" : 20.60,
				"FK_shippingAddress" : shippingAddress.getId(),
				"FK_billingAddress" : billingAddress.getId(),
				"FK_deliveryMethod" : getInstance( "DeliveryMethod@cbcommerce" ).first().getId(),
				"paidInFull" : now(),
				"approvalTime" : now(),
				"createdTime" : now(),
				"modifiedTime" : now()
			} ).refresh();
		}
		return order;
	}



	function ensureTestPayment( customer ){
		var order = ensureCustomerOrder( customer );
		return order.getPayments().len()
				? order.getPayments()[ 1 ]
				: getInstance( "Payment@cbCommerce" ).create(
				{
					"externalTransactionId" : createUUID(),
					"amount" : order.getTotal(),
					"comment" : "Test payment",
					"lastFour" : "1234",
					"paymentMethod" : "Visa",
					"FK_order" : order.getId()
				}
				).refresh();
	}


}