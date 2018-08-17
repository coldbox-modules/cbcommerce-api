/**
 * @name Customers
 * @package cbCommerce
 * @description This is the api handler for customers
 * @author Jon Clausen <jclausen@ortussolutions.com>
 **/
component extends="BaseAPIHandler" {

	//This variables is used in assembling hypermedia hrefs during data marshalling
	this.API_BASE_URL = "/api/v1/detainees";

	variables.entityDSL = "Detainee@WEATCore";
		
	/**
	* (GET) /api/v1/detainees
	*/
	function index( event, rc, prc ) cache="true" cacheTimeout="1440"{
		var searchResponse = detaineeService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );
		prc.response.setData(
			fractal.builder()
				.collection( searchResponse.getResult() )
				.withIncludes( rc.includes )
				.withTransformer( "DetaineeTransformer@WEATCore" )
				.withPagination( searchResponse.getPagination() )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
	}	

	/**
	* (GET) /api/v1/detainees/:id
	*/
	function get( event, rc, prc ) cache="true" cacheTimeout="1440"{
		prc.detainee = detaineeService.getOrFail( event.getValue( "id", "" ) );
		prc.response.setData(
			fractal.builder()
				.item( prc.detainee )
				.withIncludes( rc.includes )
				.withTransformer( "DetaineeTransformer@WEATCore" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);
	}

	/**
	* (POST) /api/v1/detainees
	*/
	function add( event, rc, prc ) {
		prc.detainee = detaineeService.new(
			properties = rc,
			ignoreEmpty = true
		);

		prc.detainee.validateOrFail();
		
		prc.detainee.save();

		prc.response.setStatusCode( STATUS.CREATED );
		prc.response.setData(
			fractal.builder()
				.item( prc.detainee )
				.withIncludes( rc.includes )
				.withTransformer( "DetaineeTransformer@WEATCore" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);

		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Cases", "id=#prc.detainee.getCase().getId()#" );
		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Detainees" );
	}	

	/**
	* (PUT|PATCH) /api/v1/detainees/:id
	*/
	function update( event, rc, prc ){
		prc.detainee = detaineeService.getOrFail( event.getValue( "id", "" ) );

		prc.detainee.populate( memento = rc );
		prc.detainee.validateOrFail();
		prc.detainee.save();

		prc.response.setStatusCode( STATUS.SUCCESS );
		prc.response.setData(
			fractal.builder()
				.item( prc.detainee )
				.withIncludes( rc.includes )
				.withTransformer( "DetaineeTransformer@WEATCore" )
				.withItemCallback( function( transformed ) {
					transformed[ "href" ] = this.API_BASE_URL & '/' & transformed.id;
					return transformed;
				} )
				.convert()
		);


		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Cases", "id=#prc.detainee.getCase().getId()#" );
		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Detainees" );
	}	

	/**
	* (DELETE) /api/v1/detainees/:id
	*/
	function delete( event, rc, prc ){
		if( ! prc.authUser.hasPermission( "WEATCore:Manage" ) ) {
			return fourOhFour( argumentCollection = arguments );
		}
		
		prc.detainee = detaineeService.getOrFail( event.getValue( "id", "" ) );

		prc.detainee.delete();
		prc.response.setStatusCode( STATUS.NO_CONTENT );
		prc.response.setData( {} );

		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Cases", "id=#prc.detainee.getCase().getId()#" );
		getCache( "template" ).clearEvent( "WEATCoreAPIv1:Detainees" );
	}

	function customerModel() provider="User@cb"{}
	function addressModel() provider="CustomerAddress@cb"{}

}