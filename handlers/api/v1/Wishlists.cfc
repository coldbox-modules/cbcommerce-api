/**
* Wishlists Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	property name="entityService" inject="WishlistService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/wishlists';
	
	// (GET) /wishlists
	function index( event, rc, prc ){
		rc[ "FK_user" ] = prc.authenticatedUser.keyValue();

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/wishlists
	function create( event, rc, prc ){
		
		prc.wishlist = entityService.newEntity().fill( rc );

		prc.wishlist.associate( prc.authenticatedUser.keyValue() );

		validateModelOrFail( prc.wishlist );

		prc.wishlist.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlist )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/wishlists/:id
	function show( event, rc, prc ){
		
		prc.wishlist = entityService.newEntity().getOrFail( rc.id );

		if( prc.wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlist )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/wishlists/:id
	function update( event, rc, prc ){
		prc.wishlist = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );
		
		if( prc.wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}
		
		prc.wishlist.fill( rc );

		validateModelOrFail( prc.wishlist );

		prc.wishlist.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlist )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/wishlists/:id
	function delete( event, rc, prc ){

		prc.wishlist = entityService.newEntity().getOrFail( rc.id );
		
		if( prc.wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.wishlist.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
