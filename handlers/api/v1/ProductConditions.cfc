/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductConditionService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-conditions';

	// (GET) /cbc/api/v1/product-categories
	function index( event, rc, prc ){
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'FK_parent ASC, name ASC';
		}
		return super.index( argumentCollection=arguments );
	}
}