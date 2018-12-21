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

}