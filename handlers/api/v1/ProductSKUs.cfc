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
		
		if( structKeyExists( rc, "discontinueOn" ) && !len( rc.discontinueOn ) ){
			structDelete( rc, "discontinueOn" );
		}

		prc.sku = entityService.newEntity().fill( rc );

		if( structKeyExists( rc, "condition" ) ){
			prc.sku.condition().associate( rc.condition.id );
		}

		if( structKeyExists( rc, "subCondition" ) ){
			prc.sku.subCondition().associate( rc.subCondition.id );
		}

		if( prc.sku.getIsConsigned() ){
			if( structKeyExists( rc.consignor, "id" ) ){
				prc.sku.consignor().associate( rc.consignor.id );
			} else {
				var consignor = getInstance( "User@cbCommerce" ).fill( rc.consignor );
				validateModelOrFail( consignor );
				consignor.save();
				//attach the user and consignor roles
				var consignorRole = getInstance( "UserRole@cbCommerce" ).where( "name", "Consignor" ).first();
				var userRole = getInstance( "UserRole@cbCommerce" ).where( "name", "user" ).first();
				consignor.roles().sync( [ consignorRole.keyValue(), userRole.keyValue() ] );
				prc.sku.consignor().associate( consignor );
			}
		} else {
			prc.sku.setFK_consignor( javacast( "null", 0 ) );
		}

		validateModelOrFail( prc.sku );

		prc.sku.save();

		if( structKeyExists( rc, "options" ) && isArray( rc.options ) ){
			rc.options.each( function( option ){
				prc.sku.options().create({ "name" : option.name, "value" : option.value });
			} );
		}

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
		//remove this key before population
		structDelete( rc, "id" );

		if( structKeyExists( rc, "discontinueOn" ) && !len( rc.discontinueOn ) ){
			var nullDiscontinue = true;
			structDelete( rc, "discontinueOn" );
		} else {
			var nullDiscontinue = false;
		}

		prc.sku.fill( rc );

		if( nullDiscontinue ){
			prc.sku.setDiscontinueOn( javacast( "null", 0 ) );
		}

		if( structKeyExists( rc, "condition" ) && structKeyExists( rc.condition, "id" ) ){
			prc.sku.condition().associate( rc.condition.id );
		}

		if( structKeyExists( rc, "subCondition" ) && structKeyExists( rc.subCondition, "id" ) ){
			prc.sku.subCondition().associate( rc.subCondition.id );
		}

		if( prc.sku.getIsConsigned() ){
			if( structKeyExists( rc.consignor, "id" ) ){
				prc.sku.consignor().associate( rc.consignor.id );
			} else {
				var consignor = getInstance( "User@cbCommerce" ).fill( rc.consignor );
				//create a bogus password
				consignor.setPassword( createUUID() );
				validateModelOrFail( consignor );
				consignor.save();
				//attach the user and consignor roles
				var consignorRole = getInstance( "UserRole@cbCommerce" ).where( "name", "consignor" ).first();
				var userRole = getInstance( "UserRole@cbCommerce" ).where( "name", "user" ).first();
				consignor.roles().sync( [ consignorRole.keyValue(), userRole.keyValue() ] );
				prc.sku.consignor().associate( consignor );
			}
		} else {
			prc.sku.setFK_consignor( javacast( "null", 0 ) );
		}

		validateModelOrFail( prc.sku );

		prc.sku.save();

		if( structKeyExists( rc, "options" ) && isArray( rc.options ) ){
			prc.sku.getOptions().each( function( option ){
				option.delete();
			} );
			rc.options.each( function( option ){
				prc.sku.options().create( { "name" : option.name, "value" : option.value } );
			} );
		}

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
