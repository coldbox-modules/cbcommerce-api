component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		super.beforeAll();
		ensureTestCustomer();
		ensureAdminUser();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Customers Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
				var testUser = getInstance( "User@cbCommerce" ).where( "email", "testcustomer@cbcommerce.com" ).first();
				if( !isNull( testUser ) ){ testUser.delete(); }
			} );

			it( "will not allow access to the list method without permissions", function(){
				authenticationService.login( variables.testCustomer );

				var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/customers",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.NOT_AUTHORIZED );
			});

            it( "can retrieve a list of customers", function(){
				authenticationService.login( variables.adminUser );
				var eventArgs = newEventArgs();
                var event = execute(
                    route = "/cbc/api/v1/customers",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct().toHaveKey( "results" ).toHaveKey( "resultsMap" )

			} );

			it( "can create a customer", function(){
				authenticationService.login( variables.adminUser );
				var payload = {
					"firstName" : "Test",
					"lastName" : "Customer",
					"email" : "testcustomer@cbcommerce.com",
					"password" : "test1ing123"
				};
				var eventArgs = newEventArgs( "POST", payload );
                var event = execute(
                    route = "/cbc/api/v1/customers",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
								.toHaveKey( "id" )
								.toHaveKey( "firstName" )
								.toHaveKey( "lastName" )
								.toHaveKey( "email" );

				expect( responseData.email ).toBe( payload.email );
			} );

			it( "can update a customer", function(){
				authenticationService.login( variables.adminUser );
				var testUser = getInstance( "User@cbCommerce" ).where( "email", "testcustomer@cbcommerce.com" ).first();
				if( isNull( testUser ) ){
					var payload = {
						"firstName" : "Test",
						"lastName" : "Customer",
						"email" : "testcustomer@cbcommerce.com",
						"password" : "test1ing123"
					};
					var eventArgs = newEventArgs( "POST", payload );
					var event = execute(
						route = "/cbc/api/v1/customers",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
					var responseData = eventArgs.prc.response.getData();
					expect( responseData ).toBeStruct()
									.toHaveKey( "id" )
									.toHaveKey( "firstName" )
									.toHaveKey( "lastName" )
									.toHaveKey( "email" );

					expect( responseData.email ).toBe( payload.email );
					testUser = getInstance( "User@cbCommerce" ).where( "email", "testcustomer@cbcommerce.com" ).first()
				}
				var eventArgs = newEventArgs( "PUT", { "lastName" : "User-Customer" } );
				var event = execute(
						route = "/cbc/api/v1/customers/" & testUser.getId(),
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
								.toHaveKey( "id" )
								.toHaveKey( "firstName" )
								.toHaveKey( "lastName" )
								.toHaveKey( "email" );
				expect( responseData.lastName ).toBe( "User-Customer" );
			} );

			it( "Can add a customer address", function(){
				authenticationService.logIn( variables.testCustomer );
				var payload = {
					"fullName" : variables.testCustomer.getFullName(),
					"address1" : "123 Anywhere Lane",
					"city" : "Grand Rapids",
					"province" : "MI",
					"postalCode" : "49546",
					"country" : "USA",
					"isPrimary" : false,
					"designation" : "shipping"
				};
				var eventArgs = newEventArgs( "POST", payload );

				var event = execute(
					route = "/cbc/api/v1/customers/#testCustomer.getId()#/addresses",
					eventArgs = eventArgs,
					renderResults = variables.saveResponses
				);

				expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );

				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toBeStruct()
								.toHaveKey( "id" )
								.toHaveKey( "fullName" )
								.toHaveKey( "address1" )
								.toHaveKey( "city" )
								.toHaveKey( "designation" );


			} );

			it( "Can update a customer address", function(){
				var addrIndex = variables.testCustomer.getAddresses().find( function( addr ){ return addr.getDesignation() == "shipping"; } );
				if( addrIndex ){
					var testAddress = variables.testCustomer.getAddresses()[ addrIndex ];
				} else {
					authenticationService.logIn( variables.testCustomer );
					var payload = {
						"fullName" : variables.testCustomer.getFullName(),
						"address1" : "123 Anywhere Lane",
						"city" : "Grand Rapids",
						"province" : "MI",
						"postalCode" : "49546",
						"country" : "USA",
						"isPrimary" : false,
						"designation" : "shipping"
					};
					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/customers/#testCustomer.getId()#/addresses",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
					var testAddress = getInstance( "CustomerAddress@cbCommerce" ).findOrFail( eventArgs.prc.response.getData().id );
				}
				authenticationService.logIn( variables.testCustomer );
				var payload = {
					"address2" : "Ste. 215"
				};
				var eventArgs = newEventArgs( "PUT", payload );

				var event = execute(
					route = "/cbc/api/v1/customers/#testCustomer.getId()#/addresses/#testAddress.getId()#",
					eventArgs = eventArgs,
					renderResults = variables.saveResponses
				);

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toBeStruct()
								.toHaveKey( "id" )
								.toHaveKey( "address2" );
				expect( responseData.address2 ).toBe( payload.address2 );

			} );

			it( "Can delete a customer", function(){
				var testUser = getInstance( "User@cbCommerce" ).where( "email", "testcustomer@cbcommerce.com" ).first();
				if( isNull( testUser ) ){
					authenticationService.login( variables.adminUser );
					var payload = {
						"firstName" : "Test",
						"lastName" : "Customer",
						"email" : "testcustomer@cbcommerce.com",
						"password" : "test1ing123"
					};
					var eventArgs = newEventArgs( "POST", payload );
					var event = execute(
						route = "/cbc/api/v1/customers",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
					var responseData = eventArgs.prc.response.getData();
					expect( responseData ).toBeStruct()
									.toHaveKey( "id" )
									.toHaveKey( "firstName" )
									.toHaveKey( "lastName" )
									.toHaveKey( "email" );

					expect( responseData.email ).toBe( payload.email );
					testUser = getInstance( "User@cbCommerce" ).where( "email", "testcustomer@cbcommerce.com" ).first()
				}

				authenticationService.login( variables.adminUser );
				var eventArgs = newEventArgs( "DELETE" );

				var event = execute(
					route = "/cbc/api/v1/customers/" & testUser.getId(),
					eventArgs = eventArgs,
					renderResults = variables.saveResponses
				);

				expectConsistentEventResponse( eventArgs.event, STATUS.NO_CONTENT );
			} );


		});

	}

}
