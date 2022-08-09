/**
* Consignment Batches Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" secured{
	property name="entityService" inject="ConsignmentBatchService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/consigment-batches';

	// (GET) /cbc/api/v1/consigment-batches
	function index( event, rc, prc ){

        if( !auth().user().hasPermission( "Products:Edit" ) ){
            rc.FK_consignor = auth().user().getId();
        }

        var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		listAppend( rc.includes, "href" );

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

	// (POST) /cbc/api/v1/consigment-batches
	function create( event, rc, prc ) secured="cbcProduct:Manage"{

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
			prc.batch.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/consigment-batches/:id
	function show( event, rc, prc ){


        prc.batch = consignmentBatchService.newEntity().getOrFail( rc.id );

        if( !auth().user().hasPermission( "Products:Edit" ) || auth().user().getId() != prc.batch.getFK_consignor() ){
            return onAuthorizationFailure( argumentCollection = arguments );
        }

		prc.response.setData(
			prc.batch.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/consigment-batches/:id
	function update( event, rc, prc ) secured="cbcProduct:Edit"{
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
			prc.batch.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	// (DELETE) /cbc/api/v1/consigment-batches/:id
	function delete( event, rc, prc ) secured="cbcProduct:Manage"{

		prc.batch = consignmentBatchService.newEntity().getOrFail( rc.id );
		prc.batch.delete();
		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
