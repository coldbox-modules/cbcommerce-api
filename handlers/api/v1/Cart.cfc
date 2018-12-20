/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	
	property name="entityService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/cart';

	// (GET) /store/api/v1/cart
	function get( event, rc, prc ){

		prc.response.setData( 
			entityService.getActiveCart().getContents()
		);
	}

	// (POST) /store/api/v1/cart/:itemId
	function addItem( event, rc, prc ){
		entityService.addItem( argumentCollection=rc ).save();

		prc.response.setData( 
			entityService.getActiveCart().getContents()
		);
		
	}

	// (PUT|PATCH) /store/api/v1/cart/:itemId
	function updateItem( event, rc, prc ){
		entityService.updateItem( argumentCollection=rc ).save();

		prc.response.setData( 
			entityService.getActiveCart().getContents()
		);
		
	}

	// (DELETE) /store/api/v1/cart/:itemId
	function deleteItem( event, rc, prc ){
		
		entityService.removeItem( argumentCollection=rc ).save();

		prc.response.setData( 
			entityService.getActiveCart().getContents()
		);

	}
	
}
