component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "UserService@cbCommerce" );
		variables.testUser = variables.model.newEntity().where( "email", "jclausen+customer@ortussolutions.com" ).first();
		variables.testPassword = "testing1234!@##$";
		if( isNull( testUser ) ){
			variables.testUser = getInstance( "User@cbCommerce" ).newEntity().fill( {
				"firstName" : "Jon",
				"lastName" : "Customer",
				"email" : "jclausen+customer@ortussolutions.com",
				"password" : variables.testPassword
			} ).save().refresh();
		} else {
			// Ensure our password is consistent
			variables.testUser.setPassword( variables.testPassword ).save();
		}
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "UserService Spec", function(){

			it( "can be created", function(){
				expect( variables.model ).toBeComponent();
			});

			it( "can retreive a new entity", function(){
				expect( variables.model.newEntity() ).toBeInstanceOf( "cbCommerce.models.User" );
			} );

			it( "tests isValidCredentials", function(){
				expect( variables.model.isValidCredentials( variables.testUser.getEmail(), variables.testPassword ) ).toBeTrue();
			} );

			it( "tests retrieveUserByUsername", function(){
				expect( variables.model.retrieveUserByUsername( variables.testUser.getEmail() ) ).toBeInstanceOf( "cbCommerce.models.User" );
			} );

			it( "tests retreiveUserById", function(){
				expect( variables.model.retrieveUserById( variables.testUser.getId() ) ).toBeInstanceOf( "cbCommerce.models.User" );
			} );

		});

	}

}

