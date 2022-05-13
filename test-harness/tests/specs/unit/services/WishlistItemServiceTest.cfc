component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "WishlistItemService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "WishlistItemService Spec", function(){

			it( "can be created", function(){
				expect( variables.model ).toBeComponent();
			});

		});

	}

}

