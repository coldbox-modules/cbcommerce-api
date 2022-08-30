/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getWirebox().getInstance( "ConsignmentBatch@cbcommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "cbCommerce.models.ConsignmentBatch Spec", function(){
			it( "Tests the model defaults", function(){
				expect( model.getExternalId() ).toBeString().toHaveLength( 0 );
				expect( model.getSummary() ).toBeString().toHaveLength( 0 );
				expect( model.getDescription() ).toBeString().toHaveLength( 0 );
				expect( model.getConsignorPercent() ).toBeNumeric().toBe( 0 );
				expect( model.getCleaningHourlyRate() ).toBeNumeric().toBe( 0 );
				expect( model.getRepairHourlyRate() ).toBeNumeric().toBe( 0 );
			});

		});

	}

}

