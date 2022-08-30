component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "EncryptionService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "EncryptionService Spec", function(){

			it( "Can encrypt a string using bCrypt", function(){
				var testPassword = "testing1234!@##$";
				var encrypted = model.bCrypt( testPassword );
				expect( encrypted ).toBeString();
				debug( encrypted );
			} );

			it( "Can test a bCrypt hash for a match", function(){
				var testPassword = "testing1234!@##$";
				var encrypted = model.bCrypt( testPassword );
				expect( model.bCryptMatches( testPassword, encrypted ) ).toBeTrue();
			} );

			it( "Can create a generic token", function(){
				var encryptionKey = generateSecretKey( 'BLOWFISH' );
				var token = model.createGenericToken( encryptionKey );
				expect( token ).toBeString();
				debug( token );

			} );

			it( "Can encrypt a value", function(){
				var testString = "foo";
				var encryptionKey = generateSecretKey( 'BLOWFISH' );
				var encrypted = model.encryptValue(
					testString,
					encryptionKey
				);
				expect( encrypted ).toBeString();

			} );

			it( "Can decrypt an encrypted string", function(){
				var testString = "foo";
				var encryptionKey = generateSecretKey( 'BLOWFISH' );
				var encrypted = model.encryptValue(
					testString,
					encryptionKey
				);
				expect( model.getDecryptedValue( encrypted, encryptionKey ) ).toBe( testString );
			} );

		});

	}

}

