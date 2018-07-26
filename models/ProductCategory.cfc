/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productCategories"  
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";
	property name="description" type="string" default="";
	
	// Relationships
	function parent(){
		return belongsTo( "ProductCategory", "FK_parent");
	}

	function children(){
		return hasMany( "ProductCategory", "FK_parent" );
	}

	function products(){
		return belongsToMany( "Product", "cbc_lookups_products_categories", "FK_category",  "FK_product" );
	}

}