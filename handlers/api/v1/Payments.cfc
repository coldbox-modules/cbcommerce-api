/**
* Payments Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	
	property name="entityService" inject="PaymentService@cbc";

	this.APIBaseURL = '/store/api/v1/payments'
	
	// (GET) /cbc/api/v1/payments
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/payments
	function create( event, rc, prc ){
		
		prc.payment = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.payment );

		prc.payment.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.payment )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/payments/:id
	function show( event, rc, prc ){
		
		prc.payment = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.payment )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/payments/:id
	function update( event, rc, prc ) secured="Payments:Edit"{
		prc.payment = entityService.newEntity().getOrFail( rc.id );

		prc.payment.fill( rc );

		validateModelOrFail( prc.payment );

		prc.payment.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.payment )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/payments/:id
	function delete( event, rc, prc ) secured="Payments:Manage"{

		prc.payment = entityService.newEntity().getOrFail( rc.id );
		prc.payment.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
