/**
* Orders Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

	property name="entityService" inject="OrderService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/orders';

	/**
	* @annotation (GET) /cbc/api/v1/orders
	* @summary Retrieves a list of orders
	* @responses { "200" : { "description" : "The return list of orders", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Orders.index.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Approve", "cbcOrder:Edit", "[Authenticated users restricted to their own orders]" ] }
	*/
	function index( event, rc, prc ) secured{
		param rc.sortOrder = "createdTime DESC";

		if( !auth().user().hasPermission( "cbcOrder:Approve,cbcOrder:Edit" ) ){
			rc.FK_user = auth().user().getId();
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData(
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setPagination(
			searchResults.pagination
		);

	}

	/**
	* @annotation (POST) /cbc/api/v1/orders
	* @summary Creates a new order - endpoint only available to users with `cbcOrder:Manage` permissions
	* @requestBody {
		"FK_user" : "5e1d79a4-55fd-46de-857b06c22454fbdd",
		"subtotal" : 10,
		"shipping" : 10,
		"fees" : 0,
		"tax" : .60,
		"discount" : 0,
		"total" : 20.60,
		"FK_shippingAddress" : "8ead8e41-1ff4-4696-a8d68ef54f917d30",
		"FK_billingAddress" : "8ead8e41-1ff4-4696-a8d68ef54f917d30",
		"FK_deliveryMethod" : "22152f42-1fee-4f7c-aaea0aa56d555775",
		"paidInFull" : "2023-03-18T16:50:32+00:00",
		"approvalTime" : "2023-03-18T16:50:32+00:00"
	}
	* @responses { "200" : { "description" : "Order successfully created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Orders.create.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Manage" ] }
	*/
	function create( event, rc, prc ) secured="cbcOrder:Manage"{

		prc.order = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.order );

		prc.order.save();

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );
	}

	/**
	* @annotation (GET) /cbc/api/v1/orders/:id
	* @params-id { "description" : "GUID identifier of the order", "in" : "path" }
	* @summary Retrieves a single order
	* @responses { "200" : { "description" : "The return object representing the order", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Orders.show.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Approve","cbcOrder:Edit","[Authenticated users restricted to their own orders]" ] }
	*/
	function show( event, rc, prc ) secured{

		prc.order = entityService.newEntity().getOrFail( rc.id );

		if( !auth().user().hasPermission( "cbcOrder:Approve,cbcOrder:Edit" ) && !cbSecure().sameUser( prc.order.getCustomer() ) ){
			return this.onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	/**
	* @annotation (PUT|PATCH) /cbc/api/v1/orders/:id
	* @summary Updates an existing order
	* @params-id { "description" : "GUID identifier of the order", "in" : "path" }
	* @requestBody {
		"FK_user" : "5e1d79a4-55fd-46de-857b06c22454fbdd",
		"subtotal" : 10,
		"shipping" : 10,
		"fees" : 0,
		"tax" : .60,
		"discount" : 0,
		"total" : 20.60,
		"FK_shippingAddress" : "8ead8e41-1ff4-4696-a8d68ef54f917d30",
		"FK_billingAddress" : "8ead8e41-1ff4-4696-a8d68ef54f917d30",
		"FK_deliveryMethod" : "22152f42-1fee-4f7c-aaea0aa56d555775",
		"paidInFull" : "2023-03-18T16:50:32+00:00",
		"approvalTime" : "2023-03-18T16:50:32+00:00"
	}
	* @responses { "200" : { "description" : "Order successfully created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Orders.update.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit","cbcOrder:Manage" ] }
	*/
	function update( event, rc, prc ) secured="cbcOrder:Edit,cbcOrder:Manage"{
		prc.order = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.order.fill( rc );

		validateModelOrFail( prc.order );

		prc.order.save();

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	/**
	* @annotation (DELETE) /cbc/api/v1/orders/:id
	* @summary Deletes an order
	* @param-id { "description" : The identifier GUID of theorder to be deleted", "in" : "path" }
	* @responses { "204" : { "description" : "Order successfully deleted", "content" : {} } }
	* @security { "JsonWebToken" : [ "cbcOrder:Manage" ] }
	**/
	function delete( event, rc, prc ) secured="cbcOrder:Manage"{

		prc.order = entityService.newEntity().getOrFail( rc.id );
		prc.order.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
