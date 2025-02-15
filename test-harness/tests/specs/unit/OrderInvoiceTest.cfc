/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "OrderInvoice@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "OrderInvoice Spec", function(){
			it( "Tests model defaults", function(){
				expect( model.getTerms() ).toBeString().toHaveLength( 0 );
				expect( model.getNotes() ).toBeString().toHaveLength( 0 );
			});
		});

	}

}
