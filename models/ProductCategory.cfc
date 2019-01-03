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
		return hasMany( "ProductCategoryMedia@cbCommerce", "FK_category" );
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

	function getActiveChildren( limit ){
		var childQuery = children().where( 'isActive', 1 )
									.hasActiveProducts()
									.orderBy( 'isFeatured', 'DESC' )
									.orderBy( 'displayOrder', 'ASC' )
									.orderBy( 'name', 'ASC' );

		if( !isNull( arguments.limit ) ){
			childQuery.limit( arguments.limit );
		}
		
		return childQuery.getResults();
	}

	function getPrimaryImageURL(){
		var catMediaItem = media()
							.where( 'FK_category', keyValue() )
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

}