/**
 * @name Customers
 * @package cbCommerce
 * @description This is the api handler for customers
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="BaseAPIHandler"{
	property name="entityService" inject="UserService@cbCommerce";

	//This variables is used in assembling hypermedia hrefs during data marshalling
	this.API_BASE_URL = "/store/api/v1/customers";

	/**
	* (GET) /store/api/v1/customers
	*/
	function index( event, rc, prc ) secured="cbcProduct:Edit,Order:Edit"{
		return super.index( argumentCollection=arguments );
	}

	/**
	* (GET) /store/api/v1/customers/:id
	*/
	function show( event, rc, prc ) secured{
		prc.user = entityService.newEntity().getOrFail( rc.id );

		if( !prc.authenticatedUser.hasPermission( "Product:Edit,Order:Edit" ) && prc.authenticatedUser.getId() != rc.id  ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData(
			prc.user.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	/**
	* (POST) /store/api/v1/customers
	*/
	function create( event, rc, prc ){
		if( auth().check() && auth().user().getEmail() == rc.email ){
			prc.response.addMessage( "You already have an account under the email #rc.email#" );
			return onExpectationFailed( argumentCollection=arguments );
		}

		prc.user = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.user );

		prc.user.save();

		if( event.getValue( "autologin", true ) ){
			auth().login( prc.user );
		}

		prc.response.setStatusCode( STATUS.CREATED );
		prc.response.setData(
			prc.user.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	/**
	* (PUT|PATCH) /store/api/v1/customers/:id
	*/
	function update( event, rc, prc ) secured{
		if( auth().user().getId() != rc.id  && !auth().user().hasPermission( "Product:Edit,Order:Edit" ) ){
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
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	/**
	* (DELETE) /store/api/v1/customers/:id
	*/
	function delete( event, rc, prc ) secured="cbcSystem:Edit"{
		prc.user = entityService.newEntity().getOrFail( rc.id );
		prc.user.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );
	}

}