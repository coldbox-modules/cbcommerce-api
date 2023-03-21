/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductConditionService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-conditions';

	/**
	* @annotation (GET) /cbc/api/v1/product-conditions
	* @summary Retrieves a list of available product conditions
	* @responses { "200" : { "description" : "The return list of conditions", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/ProductConditions.index.json" } } } } }
	*/
	function index( event, rc, prc ){
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'FK_parent ASC, name ASC';
		}
		return super.index( argumentCollection=arguments );
	}
}