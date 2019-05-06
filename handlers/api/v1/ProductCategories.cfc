/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/product-categories'
	
	// (GET) /cbc/api/v1/product-categories
	function index( event, rc, prc ){
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		var transformer = getInstance( "ProductCategoryTransformer@cbCommerce" );
		listToArray( rc.excludes ).each( function( exclude ){
			if( arrayContains( transformer.getDefaultIncludes(), exclude ) ){
				arrayDeleteAt( transformer.getDefaultIncludes(), arrayFind( transformer.getDefaultIncludes(), exclude ) );
			}
		} )

		prc.response.setData( 
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( transformer )
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

	function scopeCategoryesChildrens( query, numeric price ){
		return query.whereExists( 
			function( subQuery ){
				return subQuery.from( 'cbc_productCategories productCategories' )
						.whereColumn( 'productCategories.id', 'productCategories.FK_product'  );
			}
		);
	}

	// (POST) /cbc/api/v1/product-categories
	function create( event, rc, prc ) secured="Products:Manage"{
		
		prc.category = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbCommerce" )
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

	// (GET) /cbc/api/v1/product-categories/:id
	function show( event, rc, prc ){
		
		prc.category = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbCommerce" )
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

	// (PUT|PATCH) /cbc/api/v1/product-categories/:id
	function update( event, rc, prc ) secured="Products:Edit"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );
		
		if( structKeyExists( rc, "FK_parent" ) && !len( rc.FK_parent ) && len( prc.category.getFK_parent() ) ){
			prc.category.parent().dissociate();
			structDelete( rc, "FK_parent" );
		}

		prc.category.fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.category )
				.withIncludes( rc.includes )
				.withTransformer( "ProductCategoryTransformer@cbCommerce" )
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

	// (DELETE) /cbc/api/v1/product-categories/:id
	function delete( event, rc, prc ) secured="Products:Manage"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		prc.category.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
