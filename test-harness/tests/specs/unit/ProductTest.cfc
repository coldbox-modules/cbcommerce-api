/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app"{
	
	/*********************************** LIFE CYCLE Methods ***********************************/
	this.loadColdbox = true;
	this.unloadColdbox = true;
	
	function beforeAll(){
		super.beforeAll();
		// init the model object
		variables.model = application.wirebox.getInstance( "Product@cbc" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "Product Suite", function(){
			
			it( "Tests Product Memento Structure", function(){

				// writeDump( var = application.cbController.getModuleService().getLoadedModules() );
				writeDump( serializeJSON( application.wirebox.getInstance( "Manager@cffractal" )
					.builder()
                    .item( application.wirebox.getInstance( "Payment@cbc") )
                    .withTransformer( "BaseModelTransformer@cbc" )
					.convert() 
				)
				);
				abort;
			})

		});

	}

}
