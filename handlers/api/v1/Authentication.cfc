/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

	this.APIBaseURL = '/cbc/api/v1/authentication';

	// (GET) /cbc/api/v1/authentication/token
	function token(){
		var user = auth().check() ? auth().getUser() : getInstance( "User@cbcommerce" );
		prc.response
				.setData( { "@token" : getInstance( "JWTService@cbsecurity" ).fromUser( user )  } )
				.setStatusCode( STATUS.SUCCESS );
	}

    // Authentication check
	// (HEAD) /cbc/api/v1/authentication
	function check(){
		if( auth().check() ){
			prc.response.setStatusCode( STATUS.SUCCESS );
		} else {
			return onAuthorizationFailure( argumentCollection=arguments );
		}
	}

	// (POST) /cbc/api/v1/authentication
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

    // Authentication check
	// (GET) /cbc/api/v1/authentication
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


	// (DELETE) /cbc/api/v1/authentication/:id
	function delete( event, rc, prc ){
		auth().logout();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

    }

    // ( POST ) /cbc/api/v1/authentication/password-reset
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
