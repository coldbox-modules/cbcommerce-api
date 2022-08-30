component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "InventoryLocationService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "InventoryLocationService Spec", function(){

			it( "can be created", function(){
				expect( variables.model ).toBeComponent();
			});
			it( "can retreive a new entity", function(){
				expect( variables.model.newEntity() ).toBeInstanceOf( "cbCommerce.models.InventoryLocation" );
			} );

		});

	}

}

