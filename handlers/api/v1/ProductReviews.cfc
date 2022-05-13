/**
* Product Reviews Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

	property name="productService" inject="ProductService@cbCommerce";
	property name="entityService" inject="ProductReviewService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/products/{productID}/reviews'

	// (GET) /cbc/api/v1/products/{productId}/reviews
	function index( event, rc, prc ){
        rc[ "FK_product" ] = rc.productId;

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		if( !len( rc.excludes ) ){
			rc.excludes = "FK_product,FK_sku,FK_user";
		}

		prc.response.setData(
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{productId}', rc.productId ) & '/' & transformed[ "id" ];
				} }
			)
		).setPagination( searchResults.pagination );

	}

	// (POST) /cbc/api/v1/products/{productId}/reviews
	function create( event, rc, prc ) secured{

        prc.product = productService.findOrFail( rc.productId );
        prc.review = entityService.newEntity().fill( rc );

        prc.review.product().associate( prc.product );
        prc.review.user().association( auth().getUser() );

		validateModelOrFail( prc.review );

		prc.review.save();

		prc.response.setData(
			prc.productMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{productId}', rc.productId ) & '/' & transformed[ "id" ];
				} }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/products/{productId}/reviews/:id
	function show( event, rc, prc ){

		prc.review = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.productMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{productId}', rc.productId ) & '/' & transformed[ "id" ];
				} }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/products/{productId}/reviews/:id
	function update( event, rc, prc ) secured="cbcProduct:Manage"{
		prc.review = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.review.fill( rc );

		validateModelOrFail( prc.review );

		prc.review.save();

		prc.response.setData(
			prc.productMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{productId}', rc.productId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (DELETE) /cbc/api/v1/products/{productId}/reviews/:id
	function delete( event, rc, prc ) secured="cbcProduct:Manage"{
		prc.review = entityService.newEntity().getOrFail( rc.id );
		prc.review.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
