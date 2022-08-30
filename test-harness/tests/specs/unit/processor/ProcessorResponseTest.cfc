/**
* The base orm entity test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "ProcessorResponse@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Processor response", function(){

			it( "can be created", function(){
				expect( model ).toBeComponent();
			});

			it( "Has consistent repsponse format", function(){
				model.setError( true );
				model.setContent( "This is a test response" );
				var response = model.getMemento();
				expect( response ).toHaveKey( "error" ).toHaveKey( "content" );
			} );

		});

	}

}

