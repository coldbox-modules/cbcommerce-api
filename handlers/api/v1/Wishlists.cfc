/**
* Wishlists Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	property name="entityService" inject="WishlistService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/wishlists';

	// (GET) /wishlists
	function index( event, rc, prc ){
		rc[ "FK_user" ] = prc.authenticatedUser.keyValues()[1];

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
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setPagination(
			searchResults.pagination
		);

	}

	// (POST) /cbc/api/v1/wishlists
	function create( event, rc, prc ){

		prc.wishlist = entityService.newEntity().fill( rc );

		prc.wishlist.user().associate( prc.authenticatedUser.keyValues()[1] );

		validateModelOrFail( prc.wishlist );

		prc.wishlist.save();

		prc.response.setData(
			prc.wishlist.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/wishlists/:id
	function show( event, rc, prc ){

		prc.wishlist = entityService.newEntity().getOrFail( rc.id );

		if( prc.wishlist.getUser().keyValues()[1] != prc.authenticatedUser.keyValues()[1] ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData(
			prc.wishlist.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/wishlists/:id
	function update( event, rc, prc ){
		prc.wishlist = entityService.newEntity().getOrFail( rc.id );

		//remove this key before population
		structDelete( rc, "id" );

		if( prc.wishlist.getUser().keyValues()[1] != prc.authenticatedUser.keyValues()[1] ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.wishlist.fill( rc );

		validateModelOrFail( prc.wishlist );

		prc.wishlist.save();

		prc.response.setData(
			prc.wishlist.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);

	}

	// (DELETE) /cbc/api/v1/wishlists/:id
	function delete( event, rc, prc ){

		prc.wishlist = entityService.newEntity().getOrFail( rc.id );

		if( prc.wishlist.getUser().keyValues()[1] != prc.authenticatedUser.keyValues()[1] ){
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
