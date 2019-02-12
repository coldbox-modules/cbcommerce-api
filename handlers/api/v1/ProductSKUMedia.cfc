/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="productSKUService" inject="ProductSKUService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/skus/{skuId}/media'
	
	// (GET) /store/api/v1/skus/:skuId/media
	function index( event, rc, prc ){

		var productSKU = productSKUService.newEntity().getOrFail( rc.skuId );
		var media = productSKU.media()
							.orderBy( 'isPrimary', 'DESC')
							.orderBy( 'displayOrder', 'ASC')
							.orderBy( 'createdTime', 'ASC' )
							.getResults();

		prc.response.setData( 
			fractal.builder()
				.collection( media )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{skuId}', transformed.FK_sku ) & '/' & transformed[ "id" ];
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /store/api/v1/skus/:skuId/media
	function create( event, rc, prc ) { // secured="Products:Manage"

		var sku = productSKUService.newEntity().getOrFail( rc.skuId );

		try{
			var mediaAttachment = getInstance( "Media@cbCommerce" )
								.loadFile(
									fileInput="file",
									pathExtension="products/" & sku.getProduct().getId() & "/skus/" & sku.getId()
								);

			mediaAttachment.fill( rc );
			mediaAttachment.save();

			prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).fill( rc );
			prc.skuMedia.mediaItem().associate( mediaAttachment );
			prc.skuMedia.sku().associate( sku );
			prc.skuMedia.save();

			validateModelOrFail( prc.skuMedia );

			prc.skuMedia.save();
		} catch( any e ){
			if( !isNull( mediaAttachment ) ){
				var mediaPath = expandPath( mediaAttachment.getFileLocation() );
				if( fileExists( mediaPath ) ){
					fileDelete( mediaPath );
				}
				if( mediaAttachment.isLoaded() ){
					mediaAttachment.delete();
				}
			}
			rethrow;
		}
		

		prc.response.setData( 
			fractal.builder()
				.item( prc.skuMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{skuId}', transformed.FK_sku ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /store/api/v1/skus/:skuId/media/:id
	function show( event, rc, prc ){
		
		prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.skuMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{skuId}', transformed.FK_sku ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /store/api/v1/skus/:skuId/media/:id
	function update( event, rc, prc ) secured="Products:Edit"{
		prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );
		
		var mediaAttachment = prc.skuMedia.getMediaItem();

		mediaAttachment.fill( rc );

		validateModelOrFail( mediaAttachment );

		mediaAttachment.save();

		prc.skuMedia.fill( rc );

		validateModelOrFail( prc.skuMedia );

		prc.skuMedia.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.skuMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{skuId}', transformed.FK_sku ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /store/api/v1/skus/:skuId/media/:id
	function delete( event, rc, prc ) { // secured="Products:Manage"

		prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).getOrFail( rc.id );
		prc.skuMedia.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
