/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productCategories"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";
	property name="description" type="string" default="";
	property name="displayOrder" type="numeric" default=0;
    property name="isFeatured" type="boolean" default=0;
	property name="hitCount" type="numeric" default=0;

	//Foreign Keys
	property name="FK_parent";

	function instanceReady(){
		arrayAppend(
			this.memento.defaultIncludes,
			["media"],
			true
		);
	}

	// Relationships
	function parent(){
		return belongsTo( "ProductCategory@cbCommerce", "FK_parent");
	}

	function children(){
		return hasMany( "ProductCategory@cbCommerce", "FK_parent" );
	}

	function products(){
		return belongsToMany( "Product@cbCommerce", "cbc_lookups_products_categories", "FK_category",  "FK_product" );
	}

	function media(){
		return hasMany( "ProductCategoryMedia@cbCommerce", "FK_category" )
					.with( 'mediaItem' )
					.orderBy( 'isPrimary', 'DESC')
					.orderBy( 'displayOrder', 'ASC')
					.orderBy( 'createdTime', 'ASC' );
	}

	function scopeHasActiveProducts( query ){
		return query.whereExists(
            function( subQuery ){
				subQuery.from( 'cbc_SKUs' )
						.join( 'cbc_products', 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
						.join( 'cbc_lookups_products_categories', 'cbc_lookups_products_categories.FK_product', '=', 'cbc_products.id' )
						.whereColumn( 'cbc_lookups_products_categories.FK_category', '=', 'cbc_productCategories.id' )
						.where( 'cbc_products.isActive', 1 )
						.where( 'cbc_SKUs.isActive', 1 );
            }
        );
	}

	function scopeHasProductInCondition( required query, required string condition ){
		return query.whereExists(
            function( subQuery ){
				subQuery.from( 'cbc_SKUs' )
						.join( 'cbc_products', 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
						.join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' )
						.join( 'cbc_lookups_products_categories', 'cbc_lookups_products_categories.FK_product', '=', 'cbc_products.id' )
						.whereColumn( 'cbc_lookups_products_categories.FK_category', '=', 'cbc_productCategories.id' )
						.where( 'cbc_products.isActive', 1 )
						.where( 'cbc_SKUs.isActive', 1 )
						.whereIn( 'cbc_productConditions.name', listToArray( condition ) );
            }
        );
	}

	function getActiveChildren( limit ){
		var childQuery = children().where( 'isActive', 1 )
									.orderBy( 'displayOrder', 'ASC' )
									.orderBy( 'name', 'ASC' );

		if( !isNull( arguments.limit ) ){
			childQuery.limit( arguments.limit );
		}

		return childQuery.getResults();
	}

	function getPrimaryImageURL(){
		var catMediaItem = media()
							.with( 'mediaItem' )
							.where( 'FK_category', keyValues()[1] )
							.where( 'isActive', 1 )
							.where( 'isPrimary', 1 )
							.limit( 1 )
							.orderBy( 'displayOrder', 'ASC' );

		var results = catMediaItem.getResults();

		if( arrayLen( results ) ){
			return results[ 1 ].getMediaItem().url();
		} else {
			return "";
		}
	}

	function filterSearch(
		required struct searchCollection,
		required QueryBuilder builder
	 ){
		if( structKeyExists( searchCollection, "productCondition" ) ){
			this.scopeHasProductInCondition( builder, searchCollection.productCondition );
		}
	 }

}