/**
* Consignment Batches Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	property name="entityService" inject="ConsignmentBatchService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/consigment-batches'

	// (GET) /store/api/v1/consigment-batches
	function index( event, rc, prc ){

        if( !auth().user().hasPermission( "Products:Edit" ) ){
            rc.FK_consignor = auth().user().getId();
        }

        var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData(
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "ConsignmentBatchTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & "/" & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (POST) /store/api/v1/consigment-batches
	function create( event, rc, prc ) secured="cbcommerce:Products:Manage"{

		var sku = entityService.newEntity().getOrFail( rc.skuId );

        prc.batch = getInstance( "ConsignmentBatch@cbCommerce" ).fill( rc );
        validateModelOrFail( prc.batch );
        prc.batch.save();

        if( structKeyExists( rc, "skus" ) && isArray( rc.skus ) ){
            prc.batch.skus().sync(
                rc.skus.map( function( sku ){
                    return isSimpleValue( sku ) ? sku : sku.id;
                } )
            );
        }

		prc.response.setData(
			fractal.builder()
				.item( prc.batch )
				.withIncludes( rc.includes )
				.withTransformer( "ConsignmentBatchTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & "/" & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /store/api/v1/consigment-batches/:id
	function show( event, rc, prc ){


        prc.batch = consignmentBatchService.newEntity().getOrFail( rc.id );

        if( !auth().user().hasPermission( "Products:Edit" ) || auth().user().getId() != prc.batch.getFK_consignor() ){
            return onAuthorizationFailure( argumentCollection = arguments );
        }

		prc.response.setData(
			fractal.builder()
				.item( prc.batch )
				.withIncludes( rc.includes )
				.withTransformer( "ConsignmentBatchTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & "/" & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);
	}

	// (PUT|PATCH) /store/api/v1/consigment-batches/:id
	function update( event, rc, prc ) secured="cbcommerce:Products:Edit"{
		prc.batch = consignmentBatchService.newEntity().getOrFail( rc.id );

		prc.batch.fill( rc );

		validateModelOrFail( prc.batch );

        prc.batch.save();

        if( structKeyExists( rc, "skus" ) && isArray( rc.skus ) ){
            prc.batch.skus().sync(
                rc.skus.map( function( sku ){
                    return isSimpleValue( sku ) ? sku : sku.id;
                } )
            );
        }

		prc.response.setData(
			fractal.builder()
				.item( prc.batch )
				.withIncludes( rc.includes )
				.withTransformer( "ConsignmentBatchTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & "/" & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (DELETE) /store/api/v1/consigment-batches/:id
	function delete( event, rc, prc ) secured="cbcommerce:Products:Manage"{

		prc.batch = consignmentBatchService.newEntity().getOrFail( rc.id );
		prc.batch.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
