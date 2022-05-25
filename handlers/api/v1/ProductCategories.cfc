/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="ProductCategoryService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/product-categories';

	// (GET) /cbc/api/v1/product-categories
	function index( event, rc, prc ){
		if( rc.sortOrder == 'createdTime DESC' ){
			rc.sortOrder = 'displayOrder ASC, name ASC';
		}
		return super.index( argumentCollection=arguments );
	}

	// (POST) /cbc/api/v1/product-categories
	function create( event, rc, prc ) secured="cbcProducts:Manage"{

		prc.category = entityService.newEntity().fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData(
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		).setStatusCode( STATUS.CREATED );
	}

	// (GET) /cbc/api/v1/product-categories/:id
	function show( event, rc, prc ){

		prc.category = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/product-categories/:id
	function update( event, rc, prc ) secured="cbcProducts:Edit"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		if( structKeyExists( rc, "FK_parent" ) && !len( rc.FK_parent ) && len( prc.category.getFK_parent() ) ){
			prc.category.parent().dissociate();
			structDelete( rc, "FK_parent" );
		}

		prc.category.fill( rc );

		validateModelOrFail( prc.category );

		prc.category.save();

		prc.response.setData(
			prc.category.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	// (DELETE) /cbc/api/v1/product-categories/:id
	function delete( event, rc, prc ) secured="cbcProducts:Manage"{

		prc.category = entityService.newEntity().getOrFail( rc.id );
		prc.category.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}
