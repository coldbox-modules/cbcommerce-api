/**
* I am a new handler
*/
component{
	property name="entityService" inject="ProductService@cbc";

	this.APIBaseURL = '/cbc/api/v1/products'
	
	// (GET) /cbc/api/v1/products
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/products
	function create( event, rc, prc ) secured="Product:Manage"{
		
		prc.product = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.product );

		prc.product.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.product )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/products/:id
	function show( event, rc, prc ){
		
		prc.product = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.product )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/products/:id
	function update( event, rc, prc ) secured="Product:Edit"{
		prc.product = entityService.newEntity().getOrFail( rc.id );

		prc.product.fill( rc );

		validateModelOrFail( prc.product );

		prc.product.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.product )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbc" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/products/:id
	function delete( event, rc, prc ) secured="Product:Manage"{

		prc.product = entityService.newEntity().getOrFail( rc.id );
		prc.product.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
