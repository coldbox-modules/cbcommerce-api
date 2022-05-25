/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="productService" inject="ProductService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/products/{productId}/media';

	// (GET) /cbc/api/v1/products/:productId/media
	function index( event, rc, prc ){

		var product = productService.newEntity().getOrFail( rc.productId );
		var media = product.media()
							.orderBy( 'displayOrder', 'ASC')
							.orderBy( 'createdTime', 'ASC' )
							.getResults();
		prc.response.setData(
			resultsMapper.process(
				collection = media,
				includes=rc.includes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{productId}', rc.productId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (POST) /cbc/api/v1/products/:productId/media
	function create( event, rc, prc ) secured="cbcProducts:Edit"{

		var product = productService.newEntity().getOrFail( rc.productId );

		try{
			var mediaAttachment = getInstance( "Media@cbCommerce" )
								.loadFile(
									fileInput="file",
									pathExtension="products/" & product.getId()
								);

			mediaAttachment.fill( rc );
			mediaAttachment.save();

			prc.productMedia = getInstance( "ProductMedia@cbCommerce" ).fill( rc );
			prc.productMedia.mediaItem().associate( mediaAttachment );
			prc.productMedia.product().associate( product );

			prc.productMedia.save();

			validateModelOrFail( prc.productMedia );

			prc.productMedia.save();
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

	// (GET) /cbc/api/v1/products/:productId/media/:id
	function show( event, rc, prc ){

		prc.productMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );

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

	// (PUT|PATCH) /cbc/api/v1/products/:productId/media/:id
	function update( event, rc, prc ) secured="cbcProducts:Edit"{
		prc.productMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		var mediaAttachment = prc.productMedia.getMediaItem();

		mediaAttachment.fill( rc );

		validateModelOrFail( mediaAttachment );

		prc.productMedia.fill( rc );

		validateModelOrFail( prc.productMedia );

		prc.productMedia.save();

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

	// (DELETE) /cbc/api/v1/products/:productId/media/:id
	function delete( event, rc, prc ) secured="cbcProducts:Edit"{

		prc.productMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );
		prc.productMedia.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
