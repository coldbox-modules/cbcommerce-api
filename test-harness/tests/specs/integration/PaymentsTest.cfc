component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		super.beforeAll();
		ensureTestCustomer();
		variables.testPayment = ensureTestPayment( variables.testCustomer );
		ensureAdminUser();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Payments Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
			} );

			it( "A non-admin user may not see payments listings", function(){
				authenticationService.login( variables.testCustomer );

				var eventArgs = newEventArgs( "GET" );

				var event = execute(
                    route = "/cbc/api/v1/payments",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.NOT_AUTHORIZED );

			} );

			it( "Can retrieve a list of payments", function(){
				authenticationService.login( variables.adminUser );

				var eventArgs = newEventArgs( "GET", { "FK_order" : variables.testPayment.getOrder().getId() } );

				var event = execute(
                    route = "/cbc/api/v1/payments",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();

				debug( eventArgs.rc );

				expect( responseData ).toBeStruct()
										.toHaveKey( "results" )
										.toHaveKey( "resultsMap" );
				expect( responseData.results ).toBeArray().toHaveLength( 1 );

			} );

			it( "Can retrieve a customer payment", function(){
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs( "GET" );
				var event = execute(
                    route = "/cbc/api/v1/payments/#testPayment.getId()#",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
										.toHaveKey( "id" )
										.toHaveKey( "amount" )
										.toHaveKey( "comment" )
										.toHaveKey( "lastFour" )
										.toHaveKey( "paymentMethod" );
				expect( responseData.id ).toBe( testPayment.getId() );
			});

			xit( "Can create a customer payment", function(){
				authenticationService.login( variables.adminUser );

				var eventArgs = newEventArgs(
					"POST",
					{
						"FK_user" : variables.testCustomer.getId(),
						"subtotal" : 10,
						"shipping" : 10,
						"fees" : 0,
						"tax" : .60,
						"discount" : 0,
						"total" : 20.60,
						"FK_shippingAddress" : testPayment.getFK_shippingAddress(),
						"FK_billingAddress" : testPayment.getFK_billingAddress(),
						"FK_deliveryMethod" : testPayment.getFK_DeliveryMethod(),
						"paidInFull" : now(),
						"approvalTime" : now()
					}
				);
				var event = execute(
                    route = "/cbc/api/v1/payments",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
										.toHaveKey( "id" )
										.toHaveKey( "approvalTime" );
				expect( parseDateTime( responseData.approvalTime ) ).toBeLTE( now() );
			});

			it( "Can update a customer payment", function(){
				authenticationService.login( variables.adminUser );
				var eventArgs = newEventArgs( "PUT", { "comment" : "Updated test comment" } );
				var event = execute(
                    route = "/cbc/api/v1/payments/#testPayment.getId()#",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
										.toHaveKey( "id" )
										.toHaveKey( "comment" );
				expect( responseData.id ).toBe( testPayment.getId() );
				expect( responseData.comment ).toBeLTE( eventArgs.rc.comment );
			});
		});

	}

}
