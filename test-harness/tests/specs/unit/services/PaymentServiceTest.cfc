component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		paymentService = getInstance( "PaymentService@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Payment Service", function(){

			it( "can be created", function(){
				expect( paymentService ).toBeComponent();
			});

			it( "can retrieve processor", function(){
				var processor = paymentService.getProcessor();
				expect( processor ).toBeComponent();
				expect( processor.getName() ).toBe( "Stripe CFML" );
			});


		});

	}

}

