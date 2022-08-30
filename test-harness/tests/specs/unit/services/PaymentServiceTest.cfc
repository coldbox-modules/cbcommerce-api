component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.model = getInstance( "PaymentService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Payment Service", function(){

			it( "can be created", function(){
				expect( variables.model ).toBeComponent();
			});

			it( "can retreive a new entity", function(){
				expect( variables.model.newEntity() ).toBeInstanceOf( "cbCommerce.models.Payment" );
			} );

			it( "can retrieve processor", function(){
				var processor = variables.model.getProcessor( "Stripe" );
				expect( processor ).toBeComponent();
				expect( processor.getName() ).toBe( "Stripe CFML" );
			});


		});

	}

}

