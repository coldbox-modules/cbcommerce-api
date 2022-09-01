/**
* Orders Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{

	property name="entityService" inject="OrderService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/orders';

	// (GET) /cbc/api/v1/orders
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

	// (POST) /cbc/api/v1/orders
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

	// (GET) /cbc/api/v1/orders/:id
	function show( event, rc, prc ) secured{

		prc.order = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.order.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/orders/:id
	function update( event, rc, prc ) secured="cbcOrder:Edit"{
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

	// (DELETE) /cbc/api/v1/orders/:id
	function delete( event, rc, prc ) secured="cbcOrder:Manage"{

		prc.order = entityService.newEntity().getOrFail( rc.id );
		prc.order.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
