/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="categoryService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-categories/{categoryId}/media';

	// (GET) /cbc/api/v1/product-categories/:categoryId/media
	function index( event, rc, prc ){

		var category = categoryService.newEntity().getOrFail( rc.categoryId );

		var media = category.media()
							.orderBy( 'displayOrder', 'ASC')
							.orderBy( 'createdTime', 'ASC' )
							.getResults();

		prc.response.setData(
			resultsMapper.process(
				collection = media,
				includes=rc.includes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{categoryId}', rc.categoryId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (POST) /cbc/api/v1/product-categories/:categoryId/media
	function create( event, rc, prc ) secured="cbcProduct:Edit"{

		var category = categoryService.newEntity().getOrFail( rc.categoryId );

		try{
			var mediaAttachment = getInstance( "Media@cbCommerce" )
								.loadFile(
									fileInput="file",
									pathExtension="categories/" & category.getId()
								);

			mediaAttachment.fill( rc );
			mediaAttachment.save().refresh();

			rc.FK_media = mediaAttachment.getId();
			rc.FK_category = category.getId();

			prc.categoryMedia = getInstance( "ProductCategoryMedia@cbCommerce" ).fill( rc );

			validateModelOrFail( prc.categoryMedia );

			prc.categoryMedia.save().refresh();
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
			prc.categoryMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{categoryId}', rc.categoryId ) & '/' & transformed[ "id" ];
				} }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/product-categories/:categoryId/media/:id
	function show( event, rc, prc ){

		prc.categoryMedia = getInstance( "ProductCategoryMedia@cbCommerce" ).getOrFail( rc.id );

		prc.response.setData(
			prc.categoryMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{categoryId}', rc.categoryId ) & '/' & transformed[ "id" ];
				} }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/product-categories/:categoryId/media/:id
	function update( event, rc, prc ) secured="cbcProduct:Edit"{
		prc.categoryMedia = getInstance( "ProductCategoryMedia@cbCommerce" ).getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.categoryMedia.fill( rc );
		validateModelOrFail( prc.categoryMedia );
		prc.categoryMedia.save();

		var mediaAttachment = prc.categoryMedia.getMediaItem();
		mediaAttachment.fill( rc );
		validateModelOrFail( mediaAttachment );
		mediaAttachment.save();

		prc.response.setData(
			prc.categoryMedia.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( transformed ) {
					return replace( this.APIBaseURL, '{categoryId}', rc.categoryId ) & '/' & transformed[ "id" ];
				} }
			)
		);

	}

	// (DELETE) /cbc/api/v1/product-categories/:categoryId/media/:id
	function delete( event, rc, prc ) secured="cbcProduct:Edit"{

		prc.categoryMedia = getInstance( "ProductCategoryMedia@cbCommerce" ).getOrFail( rc.id );
		prc.categoryMedia.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
