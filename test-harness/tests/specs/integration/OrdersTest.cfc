component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.saveResponses = true;
		super.beforeAll();
		ensureTestCustomer();
		ensureAdminUser();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Orders Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
				var testUser = getInstance( "User@cbCommerce" ).where( "email", "anoncustomer@cbcommerce.com" ).first();
				if( !isNull( testUser ) ){ testUser.delete(); }
			} );

			it( "Can retreive a list of orders for a logged in customer", function(){
				authenticationService.login( variables.testCustomer );

				var eventArgs = newEventArgs( "GET" );

				var event = execute(
                    route = "/cbc/api/v1/orders",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				expect( eventArgs.rc ).toHaveKey( "FK_user" );

				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
									.toHaveKey( "results" )
									.toHaveKey( "resultsMap" );

			} );

			it( "Can retreive a list of orders by an admin", function(){
				authenticationService.login( variables.adminUser );

				var eventArgs = newEventArgs( "GET" );

				var event = execute(
                    route = "/cbc/api/v1/orders",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				expect( eventArgs.rc ).notToHaveKey( "FK_user" );

				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
									.toHaveKey( "results" )
									.toHaveKey( "resultsMap" );

			} );

			it( "Can retrieve a customer order", function(){
				var testOrder = ensureCustomerOrder( variables.testCustomer );
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs( "GET" )
				var event = execute(
                    route = "/cbc/api/v1/orders/#testOrder.getId()#",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
										.toHaveKey( "id" )
										.toHaveKey( "total" )
										.toHaveKey( "billingAddress" )
										.toHaveKey( "shippingAddress" )
										.toHaveKey( "deliveryMethod" );
				expect( responseData.id ).toBe( testOrder.getId() );
			});

			it( "Can create a customer order", function(){
				authenticationService.login( variables.adminUser );
				var testOrder = ensureCustomerOrder( variables.testCustomer );

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
						"FK_shippingAddress" : testOrder.getFK_shippingAddress(),
						"FK_billingAddress" : testOrder.getFK_billingAddress(),
						"FK_deliveryMethod" : testOrder.getFK_DeliveryMethod(),
						"paidInFull" : now(),
						"approvalTime" : now()
					}
				);
				var event = execute(
                    route = "/cbc/api/v1/orders",
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

			it( "Can update a customer order", function(){
				authenticationService.login( variables.adminUser );
				var testOrder = ensureCustomerOrder( variables.testCustomer );
				var eventArgs = newEventArgs( "PUT", { "fulFilledTime" : now() } );
				var event = execute(
                    route = "/cbc/api/v1/orders/#testOrder.getId()#",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );
				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
										.toHaveKey( "id" )
										.toHaveKey( "fulfilledTime" );
				expect( responseData.id ).toBe( testOrder.getId() );
				expect( parseDateTime( responseData.fulfilledTime ) ).toBeLTE( now() );
			});


		});

	}

}
