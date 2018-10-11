/**
* Orders Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	
	property name="entityService" inject="OrderService@cbc";

	this.APIBaseURL = '/store/api/v1/orders'
	
	// (GET) /cbc/api/v1/orders
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "OrderTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/orders
	function create( event, rc, prc ) secured="Orders:Manage"{
		
		prc.order = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.order );

		prc.order.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.order )
				.withIncludes( rc.includes )
				.withTransformer( "OrderTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/orders/:id
	function show( event, rc, prc ){
		
		prc.order = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.order )
				.withIncludes( rc.includes )
				.withTransformer( "OrderTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/orders/:id
	function update( event, rc, prc ) secured="Orders:Edit"{
		prc.order = entityService.newEntity().getOrFail( rc.id );

		prc.order.fill( rc );

		validateModelOrFail( prc.order );

		prc.order.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.order )
				.withIncludes( rc.includes )
				.withTransformer( "OrderTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/orders/:id
	function delete( event, rc, prc ) secured="Orders:Manage"{

		prc.order = entityService.newEntity().getOrFail( rc.id );
		prc.order.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}
	
}
