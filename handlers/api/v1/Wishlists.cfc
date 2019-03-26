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

		if( rc.sortOrder == "createdTime DESC" ){
			rc.sortOrder = "isDefault DESC, name ASC";
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		if( !searchResults.pagination.total ){
			entityService.newEntity().create(
				{
					"name" : $r( 'default_wishlist_title@cbCommerce', "My List" ),
					"isDefault" : 1,
					"isPublic" : 0,
					"FK_user" : rc.FK_user
				}
			);
			searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		}
		
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

		prc.wishlist.user().associate( prc.authenticatedUser.keyValue() );

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
		
		// wrap in transaction to maintain items, in case something goes wrong
		transaction{
			try{
				prc.wishlist.delete();
				transaction action="commit";
			} catch( any e ){
				transaction action="rollback";
				rethrow;
			}
		}

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
