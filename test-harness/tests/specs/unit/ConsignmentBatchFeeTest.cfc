/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getWirebox().getInstance( "ConsignmentBatchFee@cbcommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "cbCommerce.models.ConsignmentBatchFee Spec", function(){
			it( "Tests the model defaults", function(){
				expect( variables.model.getNotes() ).toHaveLength( 0 );
				expect( variables.model.getIsPaid() ).toBe( 0 );
			} );

		});

	}

}

