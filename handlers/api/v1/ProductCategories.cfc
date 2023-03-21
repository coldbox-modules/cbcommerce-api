/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-categories';

	/**
	* @annotation (GET) /cbc/api/v1/product-categories
	* @summary Retrieves a list of product categories
	* @responses { "200" : { "description" : "The return list of product categories", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategories.index.json" } } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Approve", "cbcOrder:Edit", "[Authenticated users restricted to their own product categories]" ] }
	*/
	function index( event, rc, prc ){
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}
		return super.index( argumentCollection=arguments );
	}

	/**
	* @annotation (POST) /cbc/api/v1/product-categories
	* @summary Creates a new product category
	* @requestBody {
		"name" : "Test category",
		"description" : "Test category",
		"displayOrder" : 1,
		"isFeatured" : 0
	}
	* @responses { "200" : { "description" : "Product category successfully created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategories.create.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function create( event, rc, prc ) secured="cbcProduct:Manage"{

		prc.category = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save().refresh();

		prc.response.setData(
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var categoryHref = memento.href & "/" & memento.id
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = categoryHref & "/media/" & media.id;
							} );
						}
						return categoryHref;
					}
				}
			)
		).setStatusCode( STATUS.CREATED );
	}

	/**
	* @annotation (GET) /cbc/api/v1/product-categories/:id
	* @params-id { "description" : "GUID identifier of the product category", "in" : "path" }
	* @summary Retrieves a single product category
	* @responses { "200" : { "description" : "The return object representing the product category", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategories.show.json" } } } } }
	*/
	function show( event, rc, prc ){

		prc.category = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var categoryHref = memento.href & "/" & memento.id
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = categoryHref & "/media/" & media.id;
							} );
						}
						return categoryHref;
					}
				}
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/product-categories/:id
	/**
	* @annotation (POST) /cbc/api/v1/product-categories
	* @summary Creates a new product category
	* @params-id { "description" : "GUID identifier of the product category", "in" : "path" }
	* @requestBody {
		"name" : "Test category",
		"description" : "Test category",
		"displayOrder" : 1,
		"isFeatured" : 0
	}
	* @responses { "200" : { "description" : "Product category successfully updated", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductCategories.update.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Edit","cbcProduct:Manage" ] }
	*/
	function update( event, rc, prc ) secured="cbcProduct:Edit,cbcProduct:Manage"{

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
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={
					"href" : function( item, memento ){
						var categoryHref = memento.href & "/" & memento.id
						if( memento.keyExists( "media" ) ){
							memento.media.each( function( media ){
								media[ "href" ] = categoryHref & "/media/" & media.id;
							} );
						}
						return categoryHref;
					}
				}
			)
		);

	}

	/**
	* @annotation (DELETE) /cbc/api/v1/product-categories/:id
	* @summary Deletes a product category
	* @param-id The identifier GUID of the product category to be deleted
	* @responses { "204" : { "description" : "Product category successfully deleted", "content" : {} } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	**/
	function delete( event, rc, prc ) secured="cbcProduct:Manage"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		prc.category.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
