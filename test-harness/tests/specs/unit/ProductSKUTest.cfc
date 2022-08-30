/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "ProductSKU@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "ProductSKU Spec", function(){

			it( "Tests model defaults", function(){
				expect( model.getId() ).toBeString().toHaveLength( 0 );
				expect( model.getIsVirtual() ).toBeBoolean().toBe( false );
				expect( model.getIsConsigned() ).toBeBoolean().toBe( false );
				expect( model.getAllowBackorder() ).toBeBoolean().toBe( false );
				expect( model.getIsFeatured() ).toBeBoolean().toBe( false );
				expect( model.getShowPricing() ).toBeBoolean().toBe( false );
				expect( model.getPickUpInStore() ).toBeBoolean().toBe( false );
				expect( model.getSummary() ).toBeString().toHaveLength( 0 );
				expect( model.getDescription() ).toBeString().toHaveLength( 0 );
			});

		});

	}

}
