/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getWirebox().getInstance( "InventoryLocation@cbcommerce" );

	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "LocationInventory Spec", function(){
			it( "Tests model defaults", function(){
				expect( model.getName() ).toBeString().toHaveLength( 0 );
				expect( model.getDescription() ).toBeString().toHaveLength( 0 );
				expect( model.getAddress1() ).toBeString().toHaveLength( 0 );
				expect( model.getAddress2() ).toBeString().toHaveLength( 0 );
				expect( model.getCity() ).toBeString().toHaveLength( 0 );
				expect( model.getProvince() ).toBeString().toHaveLength( 0 );
				expect( model.getPostalCode() ).toBeString().toHaveLength( 0 );
				expect( model.getCountry() ).toBeString().toHaveLength( 3 ).toBe( "USA" );
			});

		});

	}

}
