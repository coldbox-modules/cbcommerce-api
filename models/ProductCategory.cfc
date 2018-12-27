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

	function getActiveChildren( limit ){
		var childQuery = children().where( 'isActive', 1 )
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