/**
* Orders Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" { // secured

	property name="entityService" inject="OrderService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/orders'

	// (GET) /cbc/api/v1/orders
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData(
			prc.response.setData(
			resultsMapper.process(
				collection = searchResults.collection,
				includes=rc.includes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setPagination(
			searchResults.pagination
		);

	}

	// (POST) /cbc/api/v1/orders
	function create( event, rc, prc ) secured="cbcOrders:Manage"{

		prc.order = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.order );

		prc.order.save();

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/orders/:id
	function show( event, rc, prc ){

		prc.order = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/orders/:id
	function update( event, rc, prc ) secured="cbcOrders:Edit"{
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
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);

	}

	// (DELETE) /cbc/api/v1/orders/:id
	function delete( event, rc, prc ) secured="cbcOrders:Manage"{

		prc.order = entityService.newEntity().getOrFail( rc.id );
		prc.order.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
