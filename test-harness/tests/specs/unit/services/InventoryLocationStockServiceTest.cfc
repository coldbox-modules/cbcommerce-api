component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "InventoryLocationStockService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "InventoryLocationStockService Spec", function(){

			it( "can be created", function(){
				expect( variables.model ).toBeComponent();
			});
			it( "can retreive a new entity", function(){
				expect( variables.model.newEntity() ).toBeInstanceOf( "cbCommerce.models.InventoryLocationStock" );
			} );

		});

	}

}

