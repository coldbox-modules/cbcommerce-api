/**
* Wishlist Items Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	property name="entityService" inject="WishlistItemService@cbCommerce";
	property name="wishlistService" inject="WishlistService@cbCommerce";
	property name="skuService" inject="ProductSKUService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/wishlists/{wishlist}/items'
	
	// (GET) /wishlists/::wishlistId/items
	function index( event, rc, prc ){
		
		var wishlist = wishlistService.newEntity().getOrFail( rc.wishlistId );
		if( wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withTransformer( "WishlistItemTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, "{wishlist}", wishlist.keyValue() ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/wishlists/:wishlistId/items
	function create( event, rc, prc ){

		var wishlist = wishlistService.newEntity().getOrFail( rc.wishlistId );
		
		if( wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		event.paramValue( "sku", "" );
		var skuEntity = skuService.newEntity().getOrFail( rc.sku );

		if( isNull( skuEntity ) ){
			return prc.response.addMessage( "A SKU was not provided for addition to the wishlist. Could not continue" )
									.setError( true )
									.setStatus( STATUS.BAD_REQUEST );
		}

		prc.wishlistItem = entityService.newEntity().fill( {
			"baselinePrice" : skuEntity.getBasePrice(),
			"FK_sku" : skuEntity.keyValue(),
			"FK_wishlist" : wishlist.keyValue()
		} );

		validateModelOrFail( prc.wishlistItem );

		prc.wishlistItem.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlistItem )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistItemTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, "{wishlist}", wishlist.keyValue() ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/wishlists/:wishlistId/items/:id
	function show( event, rc, prc ){
		
		prc.wishlistItem = entityService.newEntity().getOrFail( rc.id );
		var wishlist = prc.wishlistItem.getWishlist();

		if( wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlistItem )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistItemTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, "{wishlist}", wishlist.keyValue() ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/wishlists/:wishlistId/items/:id
	function update( event, rc, prc ){
		prc.wishlistItem = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );
		
		var wishlist = prc.wishlistItem.getWishlist();
		
		if( wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.wishlistItem.fill( rc );

		validateModelOrFail( prc.wishlistItem );

		prc.wishlistItem.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.wishlistItem )
				.withIncludes( rc.includes )
				.withTransformer( "WishlistItemTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, "{wishlist}", wishlist.keyValue() ) & '/' & transformed[ "id" ]; 
						return transformed;
					}
				)
				.convert()
		);
		
	}

	// (DELETE) /cbc/api/v1/wishlists/:wishlistId/items/:id
	function delete( event, rc, prc ){

		prc.wishlistItem = entityService.newEntity().getOrFail( rc.id );
		var wishlist = prc.wishlistItem.getWishlist();

		if( wishlist.getUser().keyValue() != prc.authenticatedUser.keyValue() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}
		prc.wishlistItem.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
