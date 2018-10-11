/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
    property name="auth" inject="authenticationService@cbauth";

	this.APIBaseURL = '/store/api/v1/authentication'
    
    // Authentication check
	// (POST) /cbc/api/v1/authentication
	function create( event, rc, prc ){

        event.paramValue( "email", "" );
        event.paramValue( "password", "" );

        try{
            auth.authenticate( rc.email, rc.password );
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
		if( !auth.isLoggedIn() ){
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
		auth.logout();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}
	
}
