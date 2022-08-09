/**
* Product SKUs Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured="cbcProduct:Manage"{

	property name="entityService" inject="InventoryLocationStockService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-inventory';

	// (GET) /cbc/api/v1/product-inventory
	function index( event, rc, prc ){

		return super.index( argumentCollection=arguments );

	}

	// (POST) /cbc/api/v1/product-inventory
	function create( event, rc, prc ){

		prc.sku = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/product-inventory/:id
	function show( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/product-inventory/:id
	function update( event, rc, prc ){
		prc.sku = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.sku.fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData(
			prc.sku.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	// (DELETE) /cbc/api/v1/product-inventory/:id
	function delete( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );
		prc.sku.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
