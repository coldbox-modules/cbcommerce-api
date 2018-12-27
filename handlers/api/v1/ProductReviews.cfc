/**
* Product Reviews Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	
	property name="productService" inject="ProductService@cbCommerce";
	property name="entityService" inject="ProductReviewService@cbCommerce";
    property name="auth" inject="authenticationService@cbauth";

	this.APIBaseURL = '/store/api/v1/products/{productID}/reviews'
	
	// (GET) /store/api/v1/products/{productId}/reviews
	function index( event, rc, prc ){
        rc[ "FK_product" ] = rc.productId;

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "ProductReviewTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
                        transformed[ "href" ] = replace( this.APIBaseURL, '{productId}', transformed.FK_product ) & '/' & transformed[ "id" ];
                        structDelete( transformed, "FK_product" );
                        structDelete( transformed, "FK_sku" );
                        structDelete( transformed, "FK_user" ) 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /store/api/v1/products/{productId}/reviews
	function create( event, rc, prc ) secured{
    
        prc.product = productService.findOrFail( rc.productId );
        prc.review = entityService.newEntity().fill( rc );

        prc.review.product().associate( prc.product );
        prc.review.user().association( auth.getUser() );

		validateModelOrFail( prc.review );

		prc.review.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.review )
				.withIncludes( rc.includes )
				.withTransformer( "ProductReviewTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
                        transformed[ "href" ] = replace( this.APIBaseURL, '{productId}', transformed.FK_product ) & '/' & transformed[ "id" ];
                        structDelete( transformed, "FK_product" );
                        structDelete( transformed, "FK_sku" );
                        structDelete( transformed, "FK_user" )
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /store/api/v1/products/{productId}/reviews/:id
	function show( event, rc, prc ){
		
		prc.review = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.review )
				.withIncludes( rc.includes )
				.withTransformer( "ProductReviewTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
                        transformed[ "href" ] = replace( this.APIBaseURL, '{productId}', transformed.FK_product ) & '/' & transformed[ "id" ];
                        structDelete( transformed, "FK_product" );
                        structDelete( transformed, "FK_sku" );
                        structDelete( transformed, "FK_user" )
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /store/api/v1/products/{productId}/reviews/:id
	function update( event, rc, prc ) secured="Product:Manage"{
		prc.review = entityService.newEntity().getOrFail( rc.id );

		prc.review.fill( rc );

		validateModelOrFail( prc.review );

		prc.review.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.review )
				.withIncludes( rc.includes )
				.withTransformer( "ProductReviewTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
                        transformed[ "href" ] = replace( this.APIBaseURL, '{productId}', transformed.FK_product ) & '/' & transformed[ "id" ];
                        structDelete( transformed, "FK_product" );
                        structDelete( transformed, "FK_sku" );
                        structDelete( transformed, "FK_user" )
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /store/api/v1/products/{productId}/reviews/:id
	function delete( event, rc, prc ) secured="Product:Manage"{

		prc.review = entityService.newEntity().getOrFail( rc.id );
		prc.review.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
