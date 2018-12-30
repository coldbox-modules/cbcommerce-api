/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="categoryService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/product-categories/{categoryId}/media'
	
	// (GET) /store/api/v1/product-categories/:categoryId/media
	function index( event, rc, prc ){

		var category = categoryService.newEntity().getOrFail( rc.categoryId );

		var media = category.media()
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
						transformed[ "href" ] = replace( this.APIBaseURL, '{categoryId}', transformed.FK_category ) & '/' & transformed[ "id" ];
						return transformed;
					} 
				)
				.convert()
		);

	}

	// (POST) /store/api/v1/product-categories/:categoryId/media
	function create( event, rc, prc ) {

		var category = categoryService.newEntity().getOrFail( rc.categoryId );

		try{
			var mediaAttachment = getInstance( "Media@cbCommerce" )
								.loadFile(
									fileInput="uploadFile",
									pathExtension="products/" & product.getId()
								);

			mediaAttachment.fill( rc );
			mediaAttchment.save();

			prc.categoryMedia = getInstance( "ProductMedia@cbCommerce" ).fill( rc );
			prc.categoryMedia.mediaItem().associate( mediaAttachment );
			prc.categoryMedia.product().associate( product );

			prc.categoryMedia.save();

			validateModelOrFail( prc.categoryMedia );

			prc.categoryMedia.save();
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
				.item( prc.categoryMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{categoryId}', transformed.FK_category ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /store/api/v1/product-categories/:categoryId/media/:id
	function show( event, rc, prc ){
		
		prc.categoryMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );

		prc.response.setData( 
			fractal.builder()
				.item( prc.categoryMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{categoryId}', transformed.FK_category ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
	}

	// (PUT|PATCH) /store/api/v1/product-categories/:categoryId/media/:id
	function update( event, rc, prc ) { // secured="Products:Edit"
		prc.categoryMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );

		var mediaAttachment = prc.categoryMedia.getMediaItem();

		mediaAttachment.fill( rc );

		validateModelOrFail( mediaAttachment );

		prc.categoryMedia.fill( rc );

		validateModelOrFail( prc.categoryMedia );

		prc.categoryMedia.save();

		prc.response.setData( 
			fractal.builder()
				.item( prc.categoryMedia )
				.withIncludes( rc.includes )
				.withTransformer( "MediaTransformer@cbCommerce" )
				.withItemCallback( 
					function( transformed ) {
						transformed[ "href" ] = replace( this.APIBaseURL, '{categoryId}', transformed.FK_category ) & '/' & transformed[ "id" ]; 
						return transformed;
					} 
				)
				.convert()
		);
		
	}

	// (DELETE) /store/api/v1/product-categories/:categoryId/media/:id
	function delete( event, rc, prc ) { // secured="Products:Manage"

		prc.categoryMedia = getInstance( "ProductMedia@cbCommerce" ).getOrFail( rc.id );
		var mediaAttachment = prc.categoryMedia.getMediaItem();
		prc.categoryMedia.delete();
		mediaAttachment.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	
}
