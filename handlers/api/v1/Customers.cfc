/**
 * @name Customers
 * @package cbCommerce
 * @description This is the api handler for customers
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="BaseAPIHandler"{
	property name="entityService" inject="UserService@cbCommerce";
	property name="addressService" inject="CustomerAddressService@cbCommerce";

	//This variables is used in assembling hypermedia hrefs during data marshalling
	this.APIBaseURL = "/cbc/api/v1/customers";

	/**
	* @annotation (GET) /cbc/api/v1/customers
	* @summary Retrieves a list of customers
	* @responses { "200" : { "description" : "The return list of customers", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.index.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit" ] }
	*/
	function index( event, rc, prc ) secured="cbcOrder:Edit"{
		// param API to customers only
		param rc.role = "User";
		return super.index( argumentCollection=arguments );
	}

	/**
	* @annotation (GET) /cbc/api/v1/customers/:id
	* @summary Retrieves the record for an individual customer
	* @params-id The GUID identifier of the customer
	* @responses { "200" : { "description" : "The return list of customers", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.index.json" } } } }, "403" : { "description" : "User not authorized", "content" : { "application/json" : { "$ref" : "/cbcommerce/resources/apidocs/responses/BaseAPIHandler.onAuthorizationFailure.json" } } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit", "[User requested is authenticated user]" ] }
	**/
	function show( event, rc, prc ) secured{
		prc.user = entityService.newEntity().getOrFail( rc.id );

		if( !prc.authenticatedUser.hasPermission( "cbcOrder:Edit" ) && prc.authenticatedUser.getId() != rc.id  ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData(
			prc.user.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	/**
	* @annotation (POST) /cbc/api/v1/customers
	* @summary Create a new customer
	* @requestBody { "description" :  "The information for the user to create", "required" : true, "content" : { "application/json" : { "example" : { "firstName" : "Test", "lastName" : "Customer", "email" : "testcustomer@cbcommerce.dev", "password" : "test1ing123" } } } }
	* @responses { "200" : { "description" : "The record of the customer created", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.create.json" } } } }, "417" : { "description" : "A customer with the provided email already exists", "content" : { "application/json" : {} } } }
	**/
	function create( event, rc, prc ){
		if( auth().check() && auth().user().getEmail() == rc.email ){
			prc.response.addMessage( "You already have an account under the email #rc.email#" );
			return onExpectationFailed( argumentCollection=arguments );
		}

		// param this value for customers created through the admin.
		param rc.password = createUUID();

		prc.user = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.user );

		transaction{
			try{
				prc.user.save();
				var userRole = getInstance( "UserRole@cbCommerce" ).where( "name", "User" ).get();
				prc.user.roles().attach( userRole );

				if( rc.keyExists( "addresses" ) ){
					rc.addresses.each( function( address ){

					} )
				}
			} catch( any e ){
				transactionRollback();
				rethrow;
			}

		}
		if( event.getValue( "autologin", true ) ){
			auth().login( prc.user );
		}

		prc.response.setStatusCode( STATUS.CREATED );
		prc.response.setData(
			prc.user.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}


	/**
	* @annotation (PUT|PATCH) /cbc/api/v1/customers/:id
	* @summary Create a new customer
	* @params-id The GUID identifier of the customer
	* @requestBody { "description" :  "The information for the user to be updated. May include only individual fields", "required" : true, "content" : { "application/json" : { "example" : { "firstName" : "Test", "lastName" : "Customer", "email" : "testcustomer@cbcommerce.dev", "password" : "test1ing123" } } } }
	* @responses { "200" : { "description" : "The record of updated customer", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.create.json" } } } }, "417" : { "description" : "A customer with the provided email already exists", "content" : { "application/json" : {} } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit", "[Customer is authenticated user]" ] }
	**/
	function update( event, rc, prc ) secured{
		if( auth().user().getId() != rc.id  && !auth().user().hasPermission( "cbcOrder:Edit" ) ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}
		prc.user = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.user.fill( rc );
		validateModelOrFail( prc.user );
		prc.user.save();

		prc.response.setStatusCode( STATUS.SUCCESS );
		prc.response.setData(
			prc.user.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}


	/**
	* @annotation (DELETE) /cbc/api/v1/customers/:id
	* @summary Deletes a customer record
	* @param-id The identifier GUID of the customer to be deleted
	* @responses { "204" : { "description" : "User successfully deleted", "content" : {} } }
	* @security { "JsonWebToken" : [ "cbcOrder:Manage" ] }
	**/
	function delete( event, rc, prc )  secured="cbcOrder:Manage"{
		prc.user = entityService.newEntity().getOrFail( rc.id );
		prc.user.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );
	}

	/**
	* @annotation (POST) /cbc/api/v1/customers/:customerId/addresses
	* @summary Create a new customer address
	* @param-customerId The GUID identifier of the customer to which this address will belong
	* @requestBody {
		"description": "The new address to be created",
		"required": true,
		"content": {
			"application/json": {
				"example": {
					"postalCode": "49546",
					"isPrimary": false,
					"country": "USA",
					"address2": "",
					"isActive": true,
					"designation": "shipping",
					"fullName": "Jon Customer",
					"address1": "123 Anywhere Lane",
					"city": "Grand Rapids",
					"province": "MI"
				}
			}
		}
	}
	* @responses { "200" : { "description" : "The created customer address, including the identifier", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.createAddress.json" } } } }, "401" : { "description" : "The user is not authenticated", "content" : { "application/json" : {} } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit", "[Customer is authenticated user]" ] }
	**/
	function createAddress( event, rc, prc ) secured{
		if( auth().user().getId() != rc.customerId  && !auth().user().hasPermission( "cbcOrder:Edit" ) ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		rc.FK_user = rc.customerId;
		prc.address = addressService.newEntity().fill( rc );

		validateModelOrFail( prc.address );

		transaction{
			try{
				if( prc.address.getIsPrimary() ){
					addressService.newEntity()
									.newQuery()
									.where( "isPrimary", 1 )
									.update( { "isPrimary" : 0 } );
				}
				prc.address.save();
			} catch( any e ){
				transactionRollback();
				rethrow;
			}
		}

		prc.response.setData(
			prc.address.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL & "/" & rc.customerId & "/addresses"  },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );


	}

	/**
	* @annotation (PUT) /cbc/api/v1/customers/:customerId/addresses/:id
	* @summary Create a new customer address
	* @param-customerId The GUID identifier of the customer to which this address belongs
	* @param-addressId The GUID identifier of the address to be updated
	* @requestBody {
		"description": "The payload of changes to the address. May include one or more of the following",
		"required": true,
		"content": {
			"application/json": {
				"example": {
					"postalCode": "49546",
					"isPrimary": false,
					"country": "USA",
					"address2": "",
					"isActive": true,
					"designation": "shipping",
					"fullName": "Jon Customer",
					"address1": "123 Anywhere Lane",
					"city": "Grand Rapids",
					"province": "MI"
				}
			}
		}
	}
	* @responses { "200" : { "description" : "The updated customer address", "content" : { "application/json" : { "schema" : { "$ref" : "/cbcommerce/resources/apidocs/responses/Customers.createAddress.json" } } } }, "401" : { "description" : "The user is not authenticated", "content" : { "application/json" : {} } } }
	* @security { "JsonWebToken" : [ "cbcOrder:Edit", "[Customer is authenticated user]" ] }
	**/
	function updateAddress( event, rc, prc ) secured{
		if( auth().user().getId() != rc.customerId  && !auth().user().hasPermission( "Product:Edit,Order:Edit" ) ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}
		prc.address = addressService.newEntity().getOrFail( rc.id );

		prc.address.fill( rc );

		validateModelOrFail( prc.address );

		transaction{
			try{
				if( prc.address.getIsPrimary() ){
					addressService.newEntity().newQuery()
									.where( "isPrimary", 1 )
									.where( "id", "!=", rc.id )
									.update( { "isPrimary" : 0 } );
				}

				prc.address.save();
			} catch( any e ){
				transactionRollback();
				rethrow;
			}
		}


		prc.response.setData(
			prc.address.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL & "/" & rc.customerId & "/addresses"  },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);


	}

}