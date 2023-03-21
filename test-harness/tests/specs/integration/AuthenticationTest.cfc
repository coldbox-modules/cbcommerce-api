/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		ensureTestCustomer();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
		variables.jwtService = getInstance( "jwtService@cbsecurity" );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Authentication Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
			} );

			it( "can authenticate with a username and password", function(){
				var payload = {
                    "email": variables.testCustomer.getEmail(),
                    "password": variables.testPassword
                };

                var eventArgs = newEventArgs( "POST", payload );

                var event = execute(
                    route = "/cbc/api/v1/authentication",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
			} );

			it( "can retreive a blank token for an an unauthenticated user", function(){
				var eventArgs = newEventArgs();
                var event = execute(
                    route = "/cbc/api/v1/authentication/token",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct().toHaveKey( "@token" );

				var parsedToken = jwtService.parseToken( responseData[ "@token" ], false, false );

				expect( parsedToken ).toBeStruct()
									.toHaveKey( "id" )
									.toHaveKey( "scope" )
									.toHaveKey( "email" );
				expect( parsedToken.id ).toHaveLength( 0 );
			} );

			it( "can retreive a token for an an authenticated user", function(){
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs();
                var event = execute(
                    route = "/cbc/api/v1/authentication/token",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct().toHaveKey( "@token" );

				var parsedToken = jwtService.parseToken( responseData[ "@token" ], false, false );

				expect( parsedToken ).toBeStruct()
									.toHaveKey( "id" )
									.toHaveKey( "scope" )
									.toHaveKey( "email" );

				expect( parsedToken.id ).toBe( variables.testCustomer.getId() );
			} );

			it( "can check if a user is not authenticated", function(){
				var eventArgs = newEventArgs( "HEAD" );
				var event = execute(
                    route = "/cbc/api/v1/authentication",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.NOT_AUTHORIZED );
			} );

			it( "can check if a user is authenticated", function(){
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs( "HEAD" );
				var event = execute(
                    route = "/cbc/api/v1/authentication",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
			} );

			it( "can logout a user", function(){
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs( "DELETE" );
				var event = execute(
                    route = "/cbc/api/v1/authentication",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.NO_CONTENT);
				expect( variables.authenticationService.check() ).toBeFalse();
			} );

			xIt( "can peform a password reset request", function(){

			} );


		});

	}

}
