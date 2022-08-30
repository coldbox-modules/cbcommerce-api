/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "Product@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Product Spec", function(){

			it( "Tests model defaults", function(){
				expect( model.getId() ).toBeString().toHaveLength( 0 );
				expect( model.getName() ).toBeString().toHaveLength( 0 );
				expect( model.getDescription() ).toBeString().toHaveLength( 0 );
				expect( model.getShortDescription() ).toBeString().toHaveLength( 0 );
				expect( model.getExternalId() ).toBeString().toHaveLength( 0 );
				expect( model.getManufacturer() ).toBeString().toHaveLength( 0 );
				expect( model.getIsFeatured() ).toBeBoolean().toBe( false );
				expect( model.getHasOptions() ).toBeBoolean().toBe( false );
				expect( model.getRequiredOptions() ).toBeStruct().toHaveLength( 0 );
				expect( model.getDisplayOrder() ).toBeNumeric().toBe( 0 );
				expect( model.getHitCount() ).toBeNumeric().toBe( 0 );
			});

		});

	}

}

