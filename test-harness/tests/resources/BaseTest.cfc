/**
* This is the ForgeBox Base Integration Test CFC
* Place any helpers or traits for all integration tests here.
*/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	// Do not unload per test bundle to improve performance.
	this.unloadColdBox = false;

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
        super.beforeAll();
        getWireBox().autowire( this );
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	function reset(){
		structDelete( application, "wirebox" );
		structDelete( application, "cbController" );
	}

	function withRollback( target ){
		transaction{
			try{
				arguments.target();
			} catch( any e ){
				rethrow;
			} finally{
				transaction action="rollback";
			}
		}
	}

}