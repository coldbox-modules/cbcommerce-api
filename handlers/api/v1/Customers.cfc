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
	* (GET) /cbc/api/v1/customers
	*/
	function index( event, rc, prc ) secured="cbcOrder:Edit"{
		// param API to customers only
		param rc.role = "User";
		return super.index( argumentCollection=arguments );
	}

	/**
	* (GET) /cbc/api/v1/customers/:id
	*/
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
	* (POST) /cbc/api/v1/customers
	*/
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
	* (PUT|PATCH) /cbc/api/v1/customers/:id
	*/
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
	* (DELETE) /cbc/api/v1/customers/:id
	*/
	function delete( event, rc, prc )  secured="cbcOrder:Edit"{
		prc.user = entityService.newEntity().getOrFail( rc.id );
		prc.user.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );
	}

	/**
	* (POST) /cbc/api/v1/customers/:customerId/addresses
	*/
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
	* (PUT) /cbc/api/v1/customers/:customerId/addresses/:id
	*/
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