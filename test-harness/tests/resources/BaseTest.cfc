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

	function ensureAdminUser(){
		variables.adminUser = getInstance( "UserService@cbCommerce" ).newEntity().where( "email", "adminuser@cbcommerce.com" ).first();
		if( isNull( adminUser ) ){
			variables.adminUser = getInstance( "User@cbCommerce" ).newEntity().fill( {
                "firstName" : "Admin",
                "lastName" : "User",
                "email" : "adminuser@cbcommerce.com",
                "password" : "cbComm3rce4dmin"
            } ).save().refresh();
		} else {
			// Ensure our password is consistent
			variables.adminUser.setPassword( "cbComm3rce4dmin" ).save();
		}
	}

	function ensureTestCustomer(){
		variables.testCustomer = getInstance( "UserService@cbCommerce" ).newEntity().where( "email", "jclausen+customer@ortussolutions.com" ).first();
		variables.testPassword = "testing1234!@##$";
		if( isNull( testCustomer ) ){
			variables.testCustomer = getInstance( "User@cbCommerce" ).newEntity().fill( {
				"firstName" : "Jon",
				"lastName" : "Customer",
				"email" : "jclausen+customer@ortussolutions.com",
				"password" : variables.testPassword
			} ).save().refresh();
		} else {
			// Ensure our password is consistent
			variables.testCustomer.setPassword( variables.testPassword ).save();
		}
	}

}