/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/products';
	// (GET) /cbc/api/v1/products
	function index( event, rc, prc ) cache="true" cacheTimeout="1440"{

		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		rc.includes = listAppend( rc.includes, "href" );

		prc.response.setData(
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				profile=rc.profile,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var productHref = memento.href & "/" & memento.id;
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = productHref & "/media/" & media.id;
							} );
						}
						if( memento.keyExists( "skus" ) ){
							memento.skus.each( function( sku ){
								sku[ "href" ] = replace( this.APIBaseURL, "products", "skus" ) & "/" & sku.id;
							} );
						}
						return productHref;
					}
				}
			)
		).setPagination( searchResults.pagination );

	}

	// (POST) /cbc/api/v1/products
	function create( event, rc, prc ) secured="cbcProduct:Manage"{

		var payload = event.getHTTPContent( json=true, xml=false );

		// writedump( payload );
		// abort;

		prc.product = entityService.newEntity().fill( payload );

		validateModelOrFail( prc.product );

		prc.product.save();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		// sync categories after our product save
		if( structKeyExists( rc, "categories" ) ){
			prc.product.categories().sync( rc.categories.map( function( cat ){ return isSimpleValue( cat ) ? cat : cat.id; } ) );
		}

		if( !listContains( rc.includes, "href" ) ){
			rc.includes = listAppend( rc.includes, "href" );
		}

		if( !listContains( rc.includes, "skus" ) ){
			rc.includes = listAppend( rc.includes, "activeSKUs:skus" );
		}

		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				profile=rc.profile,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var productHref = memento.href & "/" & memento.id;
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = productHref & "/media/" & media.id;
							} );
						}
						if( memento.keyExists( "skus" ) ){
							memento.skus.each( function( sku ){
								sku[ "href" ] = replace( this.APIBaseURL, "products", "skus" ) & "/" & sku.id;
							} );
						}
						return productHref;
					}
				}
			)
		).setStatusCode( STATUS.CREATED );

	}

	// (GET) /cbc/api/v1/products/:id
	function show( event, rc, prc ) cache="true" cacheTimeout="1440"{

		prc.product = entityService.newEntity().getOrFail( rc.id );

		if( !listContains( rc.includes, "href" ) ){
			rc.includes = listAppend( rc.includes, "href" );
		}

		if( !listContains( rc.includes, "skus" ) ){
			rc.includes = listAppend( rc.includes, "activeSKUs:skus" );
		}

		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				profile=rc.profile,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var productHref = memento.href & "/" & memento.id;
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = productHref & "/media/" & media.id;
							} );
						}
						if( memento.keyExists( "skus" ) ){
							memento.skus.each( function( sku ){
								sku[ "href" ] = replace( this.APIBaseURL, "products", "skus" ) & "/" & sku.id;
							} );
						}
						return productHref;
					}
				}
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/products/:id
	function update( event, rc, prc ) secured="cbcProduct:Edit"{
		prc.product = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.product.fill( rc );

		validateModelOrFail( prc.product );

		prc.product.save();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		if( !listContains( rc.includes, "href" ) ){
			rc.includes = listAppend( rc.includes, "href" );
		}

		if( !listContains( rc.includes, "skus" ) ){
			rc.includes = listAppend( rc.includes, "activeSKUs:skus" );
		}

		// sync categories after our product save
		if( structKeyExists( rc, "categories" ) ){
			var categories = rc.categories.map( function( cat ){ return isSimpleValue( cat ) ? cat : cat.id; } );
			prc.product.categories().sync( categories );
		}

		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				profile=rc.profile,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var productHref = memento.href & "/" & memento.id;
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = productHref & "/media/" & media.id;
							} );
						}
						if( memento.keyExists( "skus" ) ){
							memento.skus.each( function( sku ){
								sku[ "href" ] = replace( this.APIBaseURL, "products", "skus" ) & "/" & sku.id;
							} );
						}
						return productHref;
					}
				}
			)
		);

	}

	// (DELETE) /cbc/api/v1/products/:id
	function delete( event, rc, prc ) secured="cbcProduct:Manage"{

		prc.product = entityService.newEntity().getOrFail( rc.id );
		prc.product.delete();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	// (GET) /cbc/api/v1/products/count
	function count( event, rc, prc ){
		prc.response.setData(
			{ "count" : entityService.count( rc ) }
		);
	}



}
