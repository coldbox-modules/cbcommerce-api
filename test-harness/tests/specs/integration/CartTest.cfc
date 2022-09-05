component extends="tests.resources.BaseAPITest" appMapping="/"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		variables.saveResponses = true;
		super.beforeAll();
		ensureTestCustomer();
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
		variables.cartService = getInstance( "CartService@cbCommerce" );
		variables.testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Cart Suite", function(){

			afterEach( function(){
				variables.authenticationService.logout();
				cartService.newEntity().newQuery().where( "isActive", 1 ).where( "FK_user", variables.testCustomer.getId() ).update( { "isActive" : 0 } );
			} );

			it( "can retreive/ensure a cart for an authenticated user", function(){

                var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/cart",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toHaveKey( "items" );
				expect( responseData.items ).toBeArray().toHaveLength( 0 );

			} );

			it( "can retreive/ensure a cart for an authenticated user", function(){
				authenticationService.login( variables.testCustomer );

				var eventArgs = newEventArgs();

                var event = execute(
                    route = "/cbc/api/v1/cart",
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toHaveKey( "items" );
				expect( responseData.items ).toBeArray().toHaveLength( 0 );
			} );

			it( "can add an item to a cart", function(){
				expect( variables ).toHaveKey( "testSKU" );

				authenticationService.login( variables.testCustomer );

				expect( variables.cartService.getActiveCart() ).toBeInstanceOf( "cbCommerce.models.Cart" );

				var eventArgs = newEventArgs( "POST" );

                var event = execute(
                    route = "/cbc/api/v1/cart/" & variables.testSKU.getId(),
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toHaveKey( "items" );
				expect( responseData.items ).toBeArray().toHaveLength( 1 );
				expect( responseData.items[ 1 ] ).toBeStruct()
												.toHaveKey( "quantity" )
												.toHaveKey( "sku" );

				expect( responseData.items[ 1 ].sku.id ).toBe( variables.testSKU.getId() );
				expect( responseData.items[ 1 ].quantity ).toBe( 1 );

			} );

			it( "can update an item in a cart", function(){
				expect( variables ).toHaveKey( "testSKU" );

				authenticationService.login( variables.testCustomer );

				expect( variables.cartService.getActiveCart() ).toBeInstanceOf( "cbCommerce.models.Cart" );

				var cart = variables.cartService.getActiveCart();
				variables.cartService.addItem( variables.testSKU.getId(), 1, cart );

				var eventArgs = newEventArgs( "PUT", { "quantity" : 2 } );

                var event = execute(
                    route = "/cbc/api/v1/cart/" & variables.testSKU.getId(),
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();

				expect( responseData ).toHaveKey( "items" );
				expect( responseData.items ).toBeArray().toHaveLength( 1 );
				expect( responseData.items[ 1 ] ).toBeStruct()
												.toHaveKey( "quantity" )
												.toHaveKey( "sku" );
				expect( responseData.items[ 1 ].quantity ).toBe( 2 );
			} );

			it( "can delete an item from a cart", function(){
				expect( variables ).toHaveKey( "testSKU" );

				authenticationService.login( variables.testCustomer );

				var cart = variables.cartService.getActiveCart();
				expect( cart ).toBeInstanceOf( "cbCommerce.models.Cart" )
				variables.cartService.addItem( variables.testSKU.getId(), 1, cart );

				var eventArgs = newEventArgs( "DELETE" );

                var event = execute(
                    route = "/cbc/api/v1/cart/" & variables.testSKU.getId(),
                    eventArgs = eventArgs,
                    renderResults = variables.saveResponses
                );

				expectConsistentEventResponse( eventArgs.event, STATUS.SUCCESS );
				var responseData = eventArgs.prc.response.getData();
				expect( responseData ).toHaveKey( "items" );
				expect( responseData.items ).toBeArray().toHaveLength( 0 );
			} );


		});

	}

}
