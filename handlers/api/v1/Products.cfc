/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/products'
	// (GET) /store/api/v1/products
	function index( event, rc, prc ) cache="true" cacheTimeout="1440"{

		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		event.paramValue( "activeSkusOnly", true );
		var transformer = getInstance( "ProductTransformer@cbCommerce" );
		transformer.setActiveSkusOnly( rc.activeSKUsOnly );

		prc.response.setData(
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setPagination( searchResults.pagination );

	}

	// (POST) /store/api/v1/products
	function create( event, rc, prc ) secured="cbcProducts:Manage"{

		var payload = event.getHTTPContent( json=true, xml=false );

		// writedump( payload );
		// abort;

		prc.product = entityService.newEntity().fill( payload );

		validateModelOrFail( prc.product );

		prc.product.save();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		// sync categories after our product save
		if( structKeyExists( rc, "categories" ) ){
			prc.product.categories().sync( rc.categories.map( function( cat ){ return isSimpleValue( cat ) ? cat : cat.id } ) );
		}

		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setStatusCode( STATUS.CREATED );

	}

	// (GET) /store/api/v1/products/:id
	function show( event, rc, prc ) cache="true" cacheTimeout="1440"{

		prc.product = entityService.newEntity().getOrFail( rc.id );

		event.paramValue( "activeSkusOnly", true );
		var transformer = getInstance( "ProductTransformer@cbCommerce" );
		transformer.setActiveSkusOnly( rc.activeSKUsOnly );


		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	// (PUT|PATCH) /store/api/v1/products/:id
	function update( event, rc, prc ) secured="cbcProducts:Edit"{
		prc.product = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.product.fill( rc );

		validateModelOrFail( prc.product );

		prc.product.save();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		// sync categories after our product save
		if( structKeyExists( rc, "categories" ) ){
			var categories = rc.categories.map( function( cat ){ return isSimpleValue( cat ) ? cat : cat.id } );
			prc.product.categories().sync( categories );
		}

		prc.response.setData(
			prc.product.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);

	}

	// (DELETE) /store/api/v1/products/:id
	function delete( event, rc, prc ) secured="cbcProducts:Manage"{

		prc.product = entityService.newEntity().getOrFail( rc.id );
		prc.product.delete();

		getCache( "template" ).clearEvent( 'cbCommerce:Products' );

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

	// (GET) /store/api/v1/products/count
	function count( event, rc, prc ){
		prc.response.setData(
			{ "count" : entityService.count( rc ) }
		);
	}



}
