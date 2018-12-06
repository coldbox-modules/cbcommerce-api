component extends="tests.resources.BaseTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		stripeProcessor = getInstance( "StripeProcessor@cbCommerce" );
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Stripe Processor", function(){

			it( "can be created", function(){
				expect( stripeProcessor ).toBeComponent();
			});


			it( "can give me its name and version", function(){
				var name = stripeProcessor.getName();
				var version = stripeProcessor.getVersion();

				expect(	name.len() ).toBeTrue();
				expect(	version.len() ).toBeTrue();
			});

			it( "can get the processor", function(){
				var processor = stripeProcessor.getProcessor();
				expect( processor ).toBeComponent();
			});

			it( "can make a fake charge", function(){
				var response = stripeProcessor.charge(
					amount = 1,
					source = "bogus",
					description="Unit test charge"
				);

				expect( response.getError() ).toBeTrue();
			});

			it( "can make a fake refund", function(){
				var response = stripeProcessor.refund(
					charge = 123,
					reason="Unit test refund"
				);

				expect( response.getError() ).toBeTrue();
			});

		});

	}

}

