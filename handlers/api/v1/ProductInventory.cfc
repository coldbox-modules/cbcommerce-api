/**
* Product SKUs Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured="cbcommerce:InventoryLocationStocks:Manage"{

	property name="entityService" inject="InventoryLocationStockService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/product-inventory'

	// (GET) /cbc/api/v1/product-inventory
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData(
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "InventoryLocationStockTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/product-inventory
	function create( event, rc, prc ){

		prc.sku = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.sku );

		prc.sku.save();

		prc.response.setData(
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "InventoryLocationStockTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/product-inventory/:id
	function show( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "InventoryLocationStockTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
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
			fractal.builder()
				.item( prc.sku )
				.withIncludes( rc.includes )
				.withTransformer( "InventoryLocationStockTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (DELETE) /cbc/api/v1/product-inventory/:id
	function delete( event, rc, prc ){

		prc.sku = entityService.newEntity().getOrFail( rc.id );
		prc.sku.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}

}
