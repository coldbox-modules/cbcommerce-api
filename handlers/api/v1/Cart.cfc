/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" displayName="cbc.api.v1.Cart"{

	property name="entityService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/cart';

	/**
	* @annotation (GET) /cbc/api/v1/cart
	* @summary Retrieves the contents of an authenticated user's cart
	* @responses { "200" : { "description" : "Cart retrieved", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Cart.get.json" } } } } }
	*
	**/
	function get( event, rc, prc ){

		prc.response.setData(
			entityService.getActiveCart().getContents()
		);
	}

	/**
	* @annotation (POST) /cbc/api/v1/cart/:itemId
	* @summary Adds an item to the current user's cart
	* @param-itemId { "description" : "The GUID identifier of the sku to be added to the cart", "schema" : { "type": "string" }, "required" : true, "in" : "path" }
	* @responses { "200" : { "description" : "Item added successfully", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Cart.get.json" } } } } }
	*
	**/
	function addItem( event, rc, prc ){
		prc.response.setData(
			entityService.addItem( argumentCollection=rc ).save().getContents()
		);

	}

	/**
	* @annotation (PUT|PATCH) /cbc/api/v1/cart/:itemId
	* @summary Upddate's an item in the user's cart
	* @param-itemId { "description" : "The GUID identifier of the sku to be updated in the cart", "schema" : { "type": "string" }, "required" : true, "in" : "path" }
	* @param-quantity { "description" : "The quantity of the item", "schema" : { "type": "integer" }, "required" : false, "in" : "query" }
	* @param-append { "description" : "Whether to append the item being passed ( optional, can be used in place of quantity to increment )", "schema" : { "type": "boolean" }, "required" : false, "in" : "query" }
	* @responses { "200" : { "description" : "Item added successfully", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Cart.get.json" } } } } }
	*
	**/
	function updateItem( event, rc, prc ){
		param rc.append = false;

		prc.response.setData(
			entityService.updateItem( argumentCollection=rc ).save().getContents()
		);

	}

	/**
	* @annotation (DELETE) /cbc/api/v1/cart/:itemId
	* @summary Deletes an item in a user's cart
	* @param-itemId { "description" : "The GUID identifier of the sku to be removed from the cart", "schema" : { "type": "string" }, "required" : true, "in" : "path" }
	* @responses { "200" : { "description" : "Item removed successfully", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Cart.deleteItem.json" } } } } }
	*
	**/
	function deleteItem( event, rc, prc ){
		entityService.removeItem( itemId = rc.itemId ).save();

		prc.response.setData(
			entityService.getActiveCart().getContents()
		);

	}

}
