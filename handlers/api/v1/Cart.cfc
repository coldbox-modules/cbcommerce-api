/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

	property name="entityService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/cart';

	// (GET) /cbc/api/v1/cart
	function get( event, rc, prc ){

		prc.response.setData(
			entityService.getActiveCart().getContents()
		);
	}

	// (POST) /cbc/api/v1/cart/:itemId
	function addItem( event, rc, prc ){

		prc.response.setData(
			entityService.addItem( argumentCollection=rc ).save().getContents()
		);

	}

	// (PUT|PATCH) /cbc/api/v1/cart/:itemId
	function updateItem( event, rc, prc ){
		param rc.append = false;

		prc.response.setData(
			entityService.updateItem( argumentCollection=rc ).save().getContents()
		);

	}

	// (DELETE) /cbc/api/v1/cart/:itemId
	function deleteItem( event, rc, prc ){
		entityService.removeItem( itemId = rc.itemId ).save();

		prc.response.setData(
			entityService.getActiveCart().getContents()
		);

	}

}
