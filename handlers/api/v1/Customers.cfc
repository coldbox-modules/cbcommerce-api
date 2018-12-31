/**
 * @name Customers
 * @package cbCommerce
 * @description This is the api handler for customers
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="BaseAPIHandler"  secured{
	property name="entityService" inject="UserService@cbCommerce";

	//This variables is used in assembling hypermedia hrefs during data marshalling
	this.API_BASE_URL = "/store/api/v1/customers";
		
	/**
	* (GET) /store/api/v1/customers
	*/
	function index( event, rc, prc ){
		var searchResponse = userService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		prc.response.setData(
			fractal.builder()
				.collection( searchResponse.getResult() )
				.withIncludes( rc.includes )
				.withTransformer( "UserTransformer@cbCommerce" )
				.withPagination( searchResponse.getPagination() )
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
	function get( event, rc, prc ){
		prc.user = entityService.newEntity().getOrFail( event.getValue( "id", "" ) );
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
	function add( event, rc, prc ) {
		prc.user = userService.new(
			properties = rc,
			ignoreEmpty = true
		);

		prc.user.validateOrFail();
		
		prc.user.save();

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
	function update( event, rc, prc ){
		prc.user = entityService.newEntity().getOrFail( event.getValue( "id", "" ) );
		//remove this key before population
		structDelete( rc, "id" );
		
		prc.user.populate( memento = rc );
		prc.user.validateOrFail();
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
	function delete( event, rc, prc ){

		prc.user = entityService.newEntity().getOrFail( rc.id );
		prc.user.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );
	}

	function addressModel() provider="CustomerAddress@cb"{}

}