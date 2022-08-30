/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseTest"{
	variables.tmpDirectory = expandPath( "/tests/resources/tmp" );
	variables.testFile = expandPath( "/modules/cbCommerce/resources/database/migration-data/SeedTestProducts-Images/1.jpg" );

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		variables.model = getWirebox().getInstance( "Media@cbcommerce" );
		if( !directoryExists( variables.tmpDirectory ) ){
			directoryCreate( variables.tmpDirectory );
		}
	}

	function afterAll(){
		if( directoryExists( variables.tmpDirectory ) ){
			directoryDelete( variables.tmpDirectory, true );
		}
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Media Spec", function(){

			afterEach( function(){
				if( variables.keyExists( "loadedFile" ) && fileExists( variables.loadedFile ) ){
					fileDelete( variables.loadedFile );
				}
			} );

			it( "Tests model defaults", function(){
				expect( model.getDesignation() ).toBeString().toBe( "product" );
				expect( model.getTitle() ).toBeString().toHaveLength( 0 );
				expect( model.getCaption() ).toBeString().toHaveLength( 0 );
			});

			it( "Tests the ability to load a file", function(){
				withRollback( function(){
					var entityFile = variables.tmpDirectory & "/TestMediaLoad.jpg";
					fileCopy( testFile, entityFile );
					variables.testEntity = variables.model.newEntity();
					testEntity.loadFile( filePath=entityFile ).save().refresh();
					expect( testEntity.getOriginalFileName() ).toBe( "TestMediaLoad.jpg" );
					expect( testEntity.getFileLocation() ).toBeString();
					variables.loadedFile = testEntity.getFileLocation();
					expect( testEntity.getFileSizeBytes() ).toBeString();
					expect( testEntity.isImage() ).toBe( true );
					expect( testEntity.isPDF() ).toBe( false );
					variables.testEntity.delete();
					expect( fileExists( variables.loadedFile ) ).toBeFalse();
					variables.loadedFile = javacast( "null", 0 );
				} );
			} );

			it( "Tests the ability to create a variation thumbnail of a file", function(){

				withRollback( function(){
					var entityFile = variables.tmpDirectory & "/ThumbnailTestFile.jpg";
					fileCopy( testFile, entityFile );
					variables.testEntity = variables.model.newEntity();
					testEntity.loadFile( filePath=entityFile ).save().refresh();
					expect( testEntity.getOriginalFileName() ).toBe( "ThumbnailTestFile.jpg" );
					expect( testEntity.getFileLocation() ).toBeString();
					variables.loadedFile = testEntity.getFileLocation();
					expect( testEntity.getFileSizeBytes() ).toBeString();
					expect( testEntity.isImage() ).toBe( true );
					expect( testEntity.isPDF() ).toBe( false );
					var variation = testEntity.getVariation( 100, 100 );
					debug( variation );
					expect( fileExists( variation ) ).toBeTrue();
					variables.testEntity.delete();
					expect( fileExists( variables.loadedFile ) ).toBeFalse();
					variables.loadedFile = javacast( "null", 0 );
				} );

			});

		});

	}

}
