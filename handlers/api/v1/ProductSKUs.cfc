/**
* Product SKUs Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	
	property name="entityService" inject="ProductSKUService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/skus'
	
	// (GET) /cbc/api/v1/skus
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
				.withTransformer( "ProductSKUTransformer@cbCommerce" )
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

	// (POST) /cbc/api/v1/skus
	function create( event, rc, prc ) secured="Product:Edit"{
		
		prc.sku = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "ProductSKUTransformer@cbCommerce" )
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

	// (GET) /cbc/api/v1/skus/:id
	function show( event, rc, prc ){
		
		prc.sku = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "ProductSKUTransformer@cbCommerce" )
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

	// (PUT|PATCH) /cbc/api/v1/skus/:id
	function update( event, rc, prc ) secured="Product:Edit"{
		prc.sku = entityService.newEntity().getOrFail( rc.id );

		prc.sku.fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "ProductSKUTransformer@cbCommerce" )
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

	// (DELETE) /cbc/api/v1/skus/:id
	function delete( event, rc, prc ) secured="Product:Edit"{

		prc.sku = entityService.newEntity().getOrFail( rc.id );
		prc.sku.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
