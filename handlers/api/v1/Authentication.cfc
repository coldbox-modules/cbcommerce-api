/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" displayName="cbc.api.v1.Authentication"{

	this.APIBaseURL = '/cbc/api/v1/authentication';

	/**
	* @annotation (GET) /cbc/api/v1/authentication/token
	* @summary Retrieves a valid token for an authenticated user
	* @responses { "200" : { "description" : "Token retrieved successfully", "content" : { "application/json" : { "schema" : { "$ref" : "/cbCommerce/resources/apidocs/responses/Authentication.token.json" } } } } }
	*
	**/
	function token(){
		var authenticated = auth().check();
		var user = authenticated ? auth().getUser() : getInstance( "User@cbcommerce" );
		prc.response
				.setData( { "@token" : getInstance( "JWTService@cbsecurity" ).fromUser( user )  } )
				.setStatusCode( STATUS.SUCCESS );
	}

	/**
	* @annotation (HEAD) /cbc/api/v1/authentication
	* @summary Tests whether the user performing the request is validated
	* @responses { "200" : { "description" : "The user is authenticated", "content" : {} }, "403" : { "description" : "The user is not authenticated", "content" : {} } }
	*
	**/
	function check(){
		if( auth().check() ){
			prc.response.setStatusCode( STATUS.SUCCESS );
		} else {
			return onAuthorizationFailure( argumentCollection=arguments );
		}
	}

	/**
	* @annotation (POST) /cbc/api/v1/authentication
	* @summary Authenticates the user
	* @requestBody { "description" :  "The user credentials", "required" : true, "content" : { "application/json" : { "example" : { "username" : "foo", "password" : "bar" } } } }
	* @responses { "200" : { "description" : "The user is authenticated", "content" : { "application/json" : { "success" : true } } }, "401" : { "description" : "Authentication failed", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthenticationFailure.json" } } } }
	**/
	function create( event, rc, prc ){

        event.paramValue( "email", "" );
        event.paramValue( "password", "" );

        try{
            auth().authenticate( rc.email, rc.password );
        } catch( InvalidCredentials e ){
            prc.response.addMessage( "The credentials provided were not accepted" );
            return onAuthenticationFailure( argumentCollection=arguments );
        }

		prc.response.setData(
			{
                "success": true
            }
		).setStatusCode( STATUS.CREATED );
	}

	/**
	* @annotation (GET) /cbc/api/v1/authentication
	* @summary Retrieves an authenticated user's JWT token if logged in
	* @responses { "200" : { "description" : "User is authenticated", "content" : { "application/json" : { "schema" : { "$ref" : "/cbCommerce/resources/apidocs/responses/Authentication.token.json" } } } }, "403" : { "description" : "Authentication failed", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } }  }
	*
	**/
	function get( event, rc, prc ){
		if( !auth().isLoggedIn() ){
            return onAuthorizationFailure( argumentCollection=arguments );
        }
        prc.response.setData(
            {
				"@token" : getInstance( "JWTService@cbsecurity" ).fromUser( auth().getUser() )
			}
        );

    }


	/**
	* @annotation (DELETE) /cbc/api/v1/authentication
	* @summary Logs out an authenticated user
	* @responses { "204" : { "description" : "User successfully logged out", "content" : {} } }
	*
	**/
	function delete( event, rc, prc ){
		auth().logout();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

    }

	/**
	* @annotation ( POST ) /cbc/api/v1/authentication/password-reset
	* @summary Processes a password reset request for a user
	* @requestBody { "description" :  "The credentials to reset", "required" : true, "content" : { "application/json" : { "example" : { "email" : "myemail@cbcommerce.dev" } } } }
	* @responses { "201" : { "description" : "The reset request was received", "content" : { "application/json" : { "success" : true } } } }
	**/
    function passwordReset( event, rc, prc ){
		var mailService = getInstance( "MailService@cbmailservices" );
        if( !event.valueExists( 'email' ) || !len( rc.email ) ){
            return onExpectationFailed( argumentCollection=arguments );
        }
        prc.user = getInstance( "User@cbCommerce" ).where( 'email', rc.email ).firstOrFail();
        prc.user.setResetToken( getInstance( "EncryptionService@cbCommerce" ).createGenericToken( rc.email ) ).save();

        // Prepare our contentbox objects
		if( getController().getModuleService().isModuleRegistered( "contentbox" ) ){
			getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
		}
        // reset our layout to none
        event.noLayout();

        var resetMail = mailService.newMail(
            to=prc.user.getEmail(),
            from=getSetting( "mailSettings" ).from,
            subject="Your Password Reset Request"
        );

        resetMail.setBody( renderView( view="email/user/reset", module="cbCommerce" ) );
        mailService.send( resetMail );
        prc.response.setData( { "success" : true } ).setStatusCode( STATUS.CREATED );
    }

}
