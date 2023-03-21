/**
* Product Inventory Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured="cbcProduct:Manage"{

	property name="entityService" inject="InventoryLocationStockService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-inventory';

	/**
	* @annotation (GET) /cbc/api/v1/product-inventory
	* @summary Searches product inventory
	* @responses { "200" : { "description" : "The return list of product inventory", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductInventory.index.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function index( event, rc, prc ){

		return super.index( argumentCollection=arguments );

	}

	/**
	* @annotation (POST) /cbc/api/v1/product-inventory
	* @summary Creates product inventory entry*
	* @requestBody {
		"content" : {
			"application/json" : {
				"example" : {
					"available" : 10
					"unaccounted" : 0
					"countRequired" : false
					"allowBackorder" : false
					"FK_SKU" : "8ead8e41-1ff4-4696-a8d68ef54f917d30"
					"FK_inventoryLocation" : "22152f42-1fee-4f7c-aaea0aa56d555775"
				}
			}
		}
	}
	* @responses { "200" : { "description" : "The inventory stock entry created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductInventory.create.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function create( event, rc, prc ){

		prc.sku = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );
	}

	/**
	* @annotation (GET) /cbc/api/v1/product-inventory/:id
	* @summary Retrieves a product sku inventory entry
	* @param-id { "description" : "The GUID identifier of the inventory entry", "in" : "path" }
	* @responses { "200" : { "description" : "The inventory stock entry created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductInventory.show.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function show( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	/**
	* @annotation (PUT|PATCH) /cbc/api/v1/product-inventory/:id
	* @summary Updates a product inventory entry
	* @param-id The GUID identifier of the product inventory entry
	* @requestBody {
		"content" : {
			"application/json" : {
				"example" : {
					"available" : 10
					"unaccounted" : 0
					"countRequired" : false
					"allowBackorder" : false
					"FK_SKU" : "8ead8e41-1ff4-4696-a8d68ef54f917d30"
					"FK_inventoryLocation" : "22152f42-1fee-4f7c-aaea0aa56d555775"
				}
			}
		}
	}
	* @responses { "200" : { "description" : "The inventory stock entry updated", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductInventory.update.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function update( event, rc, prc ){
		prc.sku = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.sku.fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	/**
	* @annotation (DELETE) /cbc/api/v1/product-inventory/:id
	* @summary Deletes a product inventory entry
	* @param-id The GUID identifier of the product inventory entry
	* @responses { "204" : { "description" : "Inventory entry successfully deleted", "content" : {} } }
	* @security { "JsonWebToken" : [ "cbcProduct:Manage" ] }
	*/
	function delete( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );
		prc.sku.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
