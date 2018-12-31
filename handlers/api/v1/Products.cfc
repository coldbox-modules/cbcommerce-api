/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/products'
	
	// (GET) /cbc/api/v1/products
	function index( event, rc, prc ){
		
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						if( structKeyExists( transformed, "media" ) ){
							transformed.media.each( function( mediaItem ){ 
								mediaItem[ "href" ] = transformed.href & "/media/" & mediaItem.id;
							});
						}
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/products
	function create( event, rc, prc ) { // secured="Products:Manage"

		var payload = event.getHTTPContent( json=true, xml=false );

		// writedump( payload );
		// abort;
		
		prc.product = entityService.newEntity().fill( payload );

		validateModelOrFail( prc.product );

		prc.product.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.product )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						if( structKeyExists( transformed, "media" ) ){
							transformed.media.each( function( mediaItem ){ 
								mediaItem[ "href" ] = transformed.href & "/media/" & mediaItem.id;
							});
						}
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
				.withTransformer( "ProductTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						if( structKeyExists( transformed, "media" ) ){
							transformed.media.each( function( mediaItem ){ 
								mediaItem[ "href" ] = transformed.href & "/media/" & mediaItem.id;
							});
						}
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/products/:id
	function update( event, rc, prc ) { // secured="Products:Edit"
		prc.product = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );
		
		prc.product.fill( rc );

		validateModelOrFail( prc.product );

		prc.product.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.product )
				.withIncludes( rc.includes )
				.withTransformer( "ProductTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						if( structKeyExists( transformed, "media" ) ){
							transformed.media.each( function( mediaItem ){ 
								mediaItem[ "href" ] = transformed.href & "/media/" & mediaItem.id;
							});
						}
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/products/:id
	function delete( event, rc, prc ) { // secured="Products:Manage"

		prc.product = entityService.newEntity().getOrFail( rc.id );
		prc.product.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
