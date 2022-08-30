/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getWirebox().getInstance( "InventoryLocationStock@cbCommerce" );

		// init the model object
		model.init();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "InventoryLocationStock Spec", function(){
			it( "Tests model defaults", function(){
				expect( model.getAvailable() ).toBeNumeric().toBe( 0 );
				expect( model.getUnaccounted() ).toBeNumeric().toBe( 0 );
				expect( model.getCountRequired() ).toBeBoolean().toBe( false );
				expect( model.getAllowBackorder() ).toBeBoolean().toBe( false );
			} );

		});

	}

}
