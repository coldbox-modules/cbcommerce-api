component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = new cbCommerce.models.services.CartService();
		getWirebox().autowire( variables.model );
		variables.testCustomer = getInstance( "User@cbCommerce" ).where( "email", "jclausen+customer@ortussolutions.com" ).first();
		if( isNull( testCustomer ) ){
			variables.testCustomer = getInstance( "User@cbCommerce" ).newEntity().fill( {
				"firstName" : "Jon",
				"lastName" : "Customer",
				"email" : "jclausen+customer@ortussolutions.com",
				"password" : "testing1234!@##$"
			} ).save().refresh();
		}
		variables.authenticationService = getInstance( "AuthenticationService@cbauth" );
		variables.testSKU = getInstance( "ProductSKU@cbCommerce" ).first();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "CartService Spec", function(){
			beforeEach( function(){
				model.newEntity().newQuery().where( "isActive", 1 ).where( "FK_user", variables.testCustomer.getId() ).update( { "isActive" : 0 } );
				variables.authenticationService.login( variables.testCustomer );
			} );
			afterEach( function(){
				variables.authenticationService.logout();
			} );

			it( "Tests getActiveCart", function(){
				var cart = model.getActiveCart();
				expect( cart ).toBeInstanceOf( "cbCommerce.models.Cart" );
				expect( cart.getContents() ).toBeStruct().toHaveKey( "items" );
				expect( cart.getContents().items ).toBeArray().toHaveLength( 0 );

			} );

			it( "Can add an item to a cart", function(){
				var cart = model.getActiveCart();
				variables.model.addItem( itemId=variables.testSKU.getId(), targetCart=cart );
				expect( cart.getContents() ).toBeStruct().toHaveKey( "items" );
				expect( cart.getContents().items ).toBeArray().toHaveLength( 1 );
				expect( cart.getContents().items[ 1 ] )
								.toBeStruct()
								.toHaveKey( "quantity" )
								.toHaveKey( "added" )
								.toHaveKey( "updated" )
								.toHaveKey( "product" )
								.toHaveKey( "sku" );
				debug( cart.getContents().items[ 1 ] );
				var cartSKU = cart.getContents().items[ 1 ].sku;
				expect( cartSKU ).toHaveKey( "id" );
				expect( cartSKU.id ).toBe( variables.testSKU.getId() );
			} );

			it( "Can update an existing item in cart", function(){
				var cart = model.getActiveCart();
				variables.model.addItem( itemId=variables.testSKU.getId(), targetCart=cart );
				debug( cart.getContents() );
				expect( cart.getContents() ).toBeStruct().toHaveKey( "items" );
				expect( cart.getContents().items ).toBeArray().toHaveLength( 1 );
				variables.model.updateItem(
					itemId = variables.testSKU.getId(),
					quantity = 3,
					append = true,
					targetCart = cart
				);
				expect( cart.getContents().items[ 1 ] )
								.toBeStruct()
								.toHaveKey( "quantity" )
								.toHaveKey( "added" )
								.toHaveKey( "updated" )
								.toHaveKey( "product" )
								.toHaveKey( "sku" );
				expect( cart.getContents().items[ 1 ].quantity ).toBe( 4 );

			} );

		});

	}

}

