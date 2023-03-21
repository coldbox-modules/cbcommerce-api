/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="categoryService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-categories/{categoryId}/media';

	/**
	* @annotation (GET) /cbc/api/v1/product-categories/:categoryId/media
	* @params-categoryId { "description" : "GUID identifier of the product category", "in" : "path" }
	* @summary Retrieves a list of media associated with a product category
	* @responses { "200" : { "description" : "The return list of media", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategoryMedia.index.json" } } } } }
	*/
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

	/**
	* @annotation (POST) /cbc/api/v1/product-categories/:categoryId/media
	* @summary Creates a new product category media item
	* @params-categoryId { "description" : "GUID identifier of the category", "in" : "path" }
	* @requestBody {
		"content" : {
			"multipart/form-data" : {
				"schema" : {
					"type" : "object",
					"properties" : {
						"file" : {
							"description" : "The media file to be created"
							"type" : "string",
							"contentMediaType" : "application/octet-stream",
							"required" : true
						},
						"isPrimary" : {
							"description" : "A boolean designating whether the file is the primary image for the category"
							"type" : "boolean"
						},
						"displayOrder" : {
							"description" : "The order in which this image should be displayed.  Defaults to last in the current list of media"
							"type" : "integer"
						}
					}
				}
			}
		}
	}
	* @responses { "200" : { "description" : "Media item successfully created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategoryMedia.create.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Edit" ] }
	*/
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

	/**
	* @annotation (GET) /cbc/api/v1/product-categories/:categoryId/media/:id
	* @params-categoryId { "description" : "GUID identifier of the product category", "in" : "path" }
	* @params-id { "description" : "GUID identifier of the category media item", "in" : "path" }
	* @summary Retrieves a product category media record
	* @responses { "200" : { "description" : "The media item definition", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategoryMedia.show.json" } } } } }
	*/
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

	/**
	* @annotation (PUT|PATCH) /cbc/api/v1/product-categories/:categoryId/media/:id
	* @summary Updates a product category media item
	* @params-categoryId { "description" : "GUID identifier of the category", "in" : "path" }
	* @params-id { "description" : "GUID identifier of the category media item", "in" : "path" }
	* @requestBody {
		"content" : {
			"application/json" : {
				"schema" : {
					"type" : "object",
					"properties" : {
						"isPrimary" : {
							"description" : "A boolean designating whether the file is the primary image for the category"
							"type" : "boolean"
						},
						"displayOrder" : {
							"description" : "The order in which this image should be displayed.  Defaults to last in the current list of media"
							"type" : "integer"
						}
					}
				}
			}
		}
	}
	* @responses { "200" : { "description" : "Media item successfully updated", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategoryMedia.update.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Edit" ] }
	*/
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

	/**
	* @annotation (DELETE) /cbc/api/v1/product-categories/:categoryId/media/:id
	* @summary Deletes a product category media item
	* @params-categoryId { "description" : "GUID identifier of the category", "in" : "path" }
	* @param-id { "description" : The identifier GUID of the item to be deleted", "in" : "path" }
	* @responses { "204" : { "description" : "Order successfully deleted", "content" : {} } }
	* @security { "JsonWebToken" : [ "cbcProduct:Edit" ] }
	**/
	function delete( event, rc, prc ) secured="cbcProduct:Edit"{

		prc.categoryMedia = getInstance( "ProductCategoryMedia@cbCommerce" ).getOrFail( rc.id );
		prc.categoryMedia.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
