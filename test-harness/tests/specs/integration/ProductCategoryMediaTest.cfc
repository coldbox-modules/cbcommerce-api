component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.saveResponses = true;
		super.beforeAll();
		ensureAdminUser();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		xdescribe( "Orders Suite", function(){

			afterEach( function(){
				authenticationService.logout();
			} );

			it( "Any user can list product category media", function(){
				var eventArgs = newEventArgs();

				var event = execute(
                    route = "/cbc/api/v1/product-categories",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

				var responseData = eventArgs.prc.response.getData();

			} );

			it( "Can create a product category", function(){
				authenticationService.login( variables.adminUser );
				withRollback( function(){
					var payload = {
						"name" : "Test category",
						"description" : "Test category",
						"displayOrder" : 1,
						"isFeatured" : 0
					};

					var eventArgs = newEventArgs( "POST", payload );

					var event = execute(
						route = "/cbc/api/v1/product-categories",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.CREATED );

					var responseData = eventArgs.prc.response.getData();
					expect( responseData ).toBeStruct()
											.toHaveKey( "id" )
											.toHaveKey( "name" )
											.toHaveKey( "description" );
					expect( responseData.name ).toBe( payload.name );
				} );

			});

			it( "Can update a product category", function(){
				withRollback( function(){
					authenticationService.login( variables.adminUser );
					var testCategory = getInstance( "ProductCategory@cbcommerce" ).first()
										?:
										getInstance( "ProductCategory@cbCommerce" ).create({
												"name" : "Test category",
												"description" : "Test category",
												"displayOrder" : 1,
												"isFeatured" : 0
											}).refresh();
					var eventArgs = newEventArgs( "PUT", { "description" : "Test category updated" } );

					var event = execute(
						route = "/cbc/api/v1/product-categories/#testCategory.getId()#",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );

					var responseData = eventArgs.prc.response.getData();

					expect( responseData ).toBeStruct()
											.toHaveKey( "id" )
											.toHaveKey( "name" )
											.toHaveKey( "description" );

					expect( responseData.description ).toBe( "Test category updated" );
				} );

			} );

			it( "Can delete a product category", function(){
				withRollback( function(){
					authenticationService.login( variables.adminUser );

					var testCategory = getInstance( "ProductCategory@cbcommerce" ).first()
										?:
										getInstance( "ProductCategory@cbCommerce" ).create({
											"name" : "Test category",
											"description" : "Test category",
											"displayOrder" : 1,
											"isFeatured" : 0
										}).refresh();
					var eventArgs = newEventArgs( "DELETE" );

					var event = execute(
						route = "/cbc/api/v1/product-categories/#testCategory.getId()#",
						eventArgs = eventArgs,
						renderResults = variables.saveResponses
					);

					expectConsistentEventResponse( eventArgs.event, STATUS.NO_CONTENT );
				} );
			} );

		});

	}

	function createTestCategoryWithMedia(){}

}
