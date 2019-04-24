/**
 * @name Customers
 * @package cbCommerce
 * @description This is the api handler for customers
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="BaseAPIHandler"{
	property name="entityService" inject="UserService@cbCommerce";
	property name="auth" inject="authenticationService@cbauth";

	//This variables is used in assembling hypermedia hrefs during data marshalling
	this.API_BASE_URL = "/store/api/v1/customers";

	/**
	* (GET) /store/api/v1/customers
	*/
	function index( event, rc, prc ) secured="Product:Edit,Order:Edit"{
		var searchResponse = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		prc.response.setData(
			fractal.builder()
				.collection( searchResponse.collection )
				.withIncludes( rc.includes )
				.withTransformer( "UserTransformer@cbCommerce" )
				.withPagination( searchResponse.pagination )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
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
			fractal.builder()
				.item( prc.user )
				.withIncludes( rc.includes )
				.withTransformer( "UserTransformer@cbCommerce" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
	}

	/**
	* (POST) /store/api/v1/customers
	*/
	function create( event, rc, prc ){
		if( auth.check() && auth.user().getEmail() == rc.email ){
			prc.response.addMessage( "You already have an account under the email #rc.email#" );
			return onExpectationFailed( argumentCollection=arguments );
		}
		
		prc.user = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.user );

		prc.user.save();

		if( event.getValue( "autologin", true ) ){
			auth.login( prc.user );
		}

		prc.response.setStatusCode( STATUS.CREATED );
		prc.response.setData(
			fractal.builder()
				.item( prc.user )
				.withIncludes( rc.includes )
				.withTransformer( "UserTransformer@cbCommerce" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
	}

	/**
	* (PUT|PATCH) /store/api/v1/customers/:id
	*/
	function update( event, rc, prc ) secured{
		if( auth.user().getId() != rc.id  && !auth.user().hasPermission( "Product:Edit,Order:Edit" ) ){
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
			fractal.builder()
				.item( prc.user )
				.withIncludes( rc.includes )
				.withTransformer( "UserTransformer@cbCommerce" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
	}

	/**
	* (DELETE) /store/api/v1/customers/:id
	*/
	function delete( event, rc, prc ) secured="System:Edit"{
		prc.user = entityService.newEntity().getOrFail( rc.id );
		prc.user.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );
	}

}