/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductCategoryService@cbc";

	this.APIBaseURL = '/store/api/v1/product-categories'
	
	// (GET) /cbc/api/v1/product-categories
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/product-categories
	function create( event, rc, prc ) secured="Products:Manage"{
		
		prc.category = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/product-categories/:id
	function show( event, rc, prc ){
		
		prc.category = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/product-categories/:id
	function update( event, rc, prc ) secured="Products:Edit"{
		prc.category = entityService.newEntity().getOrFail( rc.id );

		prc.category.fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/product-categories/:id
	function delete( event, rc, prc ) secured="Products:Manage"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		prc.category.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
