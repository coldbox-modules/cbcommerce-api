/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "OrderItem@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "cbCommerce.models.OrderItem Spec", function(){
			it( "Tests model defaults", function(){
				expect( model.getIsVirtual() ).toBeBoolean().toBe( false );
				expect( model.getQuantityOrdered() ).toBeNumeric().toBe( 1 );
				expect( model.getQuantityCancelled() ).toBeNumeric().toBe( 0 );
				expect( model.getQuantityRefunded() ).toBeNumeric().toBe( 0 );
				expect( model.getQuantityDownloaded() ).toBeNumeric().toBe( 0 );
				expect( model.getProductSnapshot() ).toBeStruct().toHaveLength( 0 );
			});

		});

	}

}

