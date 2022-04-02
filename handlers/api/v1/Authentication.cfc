/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
    property name="mailService" inject="MailService@cbmailservices";

	this.APIBaseURL = '/store/api/v1/authentication'

    // Authentication check
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
                "success" : true
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
        if( !event.valueExists( 'email' ) || !len( rc.email ) ){
            return onExpectationFailed( argumentCollection=arguments );
        }
        prc.user = getInstance( "User@cbCommerce" ).where( 'email', rc.email ).firstOrFail();
        prc.user.setResetToken( getInstance( "EncryptionService@cbCommerce" ).createGenericToken( rc.email ) ).save();

        // Prepare our contentbox objects
        getInstance( "CBHelper@cb" ).prepareUIRequest( "modules" );
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
