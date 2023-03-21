component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
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

		describe( "ConsignmentBatches Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
			} );

			it( "Will not allow access without authentication", function(){
				var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/consignment-batches",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.NOT_AUTHENTICATED );
			} );

			it( "Can retrieve consignment batches for a non-admin user", function(){
				authenticationService.login( variables.testCustomer );
				var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/consignment-batches",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
									.toHaveKey( "results" )
									.toHaveKey( "resultsMap" );
			} );

			it( "Can retrieve consignment batches for an admin user", function(){
				authenticationService.login( variables.AdminUser );
				var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/consignment-batches",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toBeStruct()
									.toHaveKey( "results" )
									.toHaveKey( "resultsMap" );
			} );

			it( "Can create a consignment batch", function(){
				authenticationService.login( variables.AdminUser );
				withRollback( function(){
					var testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
					var payload = {
						"externalId" : createUUID(),
						"summary" : "test consignment batch",
						"description" : "test consignment batch",
						"consignorPercent" : 25,
						"cleaningHourlyRate" : 25,
						"repairHourlyRate" : 25,
						"FK_consignor" : variables.testCustomer.getId(),
						"skus" : [ testSKU.getId() ],
						"includes" : "skus"
					};

					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );
					var responseData = eventArgs.prc.response.getData();
					expect( responseData ).toBeStruct()
											.toHaveKey( "id" )
											.toHaveKey( "skus" );
					expect( responseData.skus ).toBeArray().toHaveLength( 1 );

				} );
			} );

			it( "Can retrieve a consignment batch", function(){
				authenticationService.login( variables.AdminUser );
				withRollback( function(){
					var testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
					var payload = {
						"externalId" : createUUID(),
						"summary" : "test consignment batch",
						"description" : "test consignment batch",
						"consignorPercent" : 25,
						"cleaningHourlyRate" : 25,
						"repairHourlyRate" : 25,
						"FK_consignor" : variables.testCustomer.getId(),
						"skus" : [ testSKU.getId() ],
						"includes" : "skus"
					};

					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );

					var batchId = eventArgs.prc.response.getData().id;

					eventArgs = newEventArgs();

					var event = execute(
						route = "/cbc/api/v1/consignment-batches/" & batchId,
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

					expect( eventArgs.prc.response.getData().id ).toBe( batchId );

				} );
			} );

			it( "Can update a consignment batch", function(){
				authenticationService.login( variables.AdminUser );
				withRollback( function(){
					var testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
					var payload = {
						"externalId" : createUUID(),
						"summary" : "test consignment batch",
						"description" : "test consignment batch",
						"consignorPercent" : 25,
						"cleaningHourlyRate" : 25,
						"repairHourlyRate" : 25,
						"FK_consignor" : variables.testCustomer.getId(),
						"skus" : [ testSKU.getId() ],
						"includes" : "skus"
					};

					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );

					var batchId = eventArgs.prc.response.getData().id;

					eventArgs = newEventArgs( "PUT", { "externalID" : "test123" } );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches/" & batchId,
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

					expect( eventArgs.prc.response.getData().externalId ).toBe( "test123" );

				} );
			} );

			it( "Can delete a consignment batch", function(){
				authenticationService.login( variables.AdminUser );
				withRollback( function(){
					var testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
					var payload = {
						"externalId" : createUUID(),
						"summary" : "test consignment batch",
						"description" : "test consignment batch",
						"consignorPercent" : 25,
						"cleaningHourlyRate" : 25,
						"repairHourlyRate" : 25,
						"FK_consignor" : variables.testCustomer.getId(),
						"skus" : [ testSKU.getId() ],
						"includes" : "skus"
					};

					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );

					var batchId = eventArgs.prc.response.getData().id;

					eventArgs = newEventArgs( "DELETE" );

					var event = execute(
						route = "/cbc/api/v1/consignment-batches/" & batchId,
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.NO_CONTENT );

				} );
			} );


		});

	}

}
