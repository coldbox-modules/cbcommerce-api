/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="productSKUService" inject="ProductSKUService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/skus/{skuId}/media';

	// (GET) /cbc/api/v1/skus/:skuId/media
	function index( event, rc, prc ){

		var productSKU = productSKUService.newEntity().getOrFail( rc.skuId );
		var media = productSKU.media()
							.orderBy( 'isPrimary', 'DESC')
							.orderBy( 'displayOrder', 'ASC')
							.orderBy( 'createdTime', 'ASC' )
							.getResults();

		prc.response.setData(
			resultsMapper.process(
				collection = media,
				includes=rc.includes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{skuId}', rc.skuId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (POST) /cbc/api/v1/skus/:skuId/media
	function create( event, rc, prc ) secured="cbcProducts:Edit"{

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
			prc.skuMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{skuId}', rc.skuId ) & '/' & transformed[ "id" ];
				} }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/skus/:skuId/media/:id
	function show( event, rc, prc ){

		prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).getOrFail( rc.id );

		prc.response.setData(
			prc.skuMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{skuId}', rc.skuId ) & '/' & transformed[ "id" ];
				} }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/skus/:skuId/media/:id
	function update( event, rc, prc ) secured="cbcProducts:Edit"{
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
			prc.skuMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{skuId}', rc.skuId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (DELETE) /cbc/api/v1/skus/:skuId/media/:id
	function delete( event, rc, prc ) secured="cbcProducts:Edit"{

		prc.skuMedia = getInstance( "ProductSKUMedia@cbCommerce" ).getOrFail( rc.id );
		prc.skuMedia.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
