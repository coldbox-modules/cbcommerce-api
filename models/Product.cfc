/**
* cboxCommerce Product Object
*/
component   table="cbc_products" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";
	property name="shortDescription" type="string" default="";
	property name="description" type="string" default="";
	property name="hasOptions" type="boolean" default="false";
	property name="requiredOptions" type="string" default="{}";

	// Relationships
	function skus(){
		return hasMany( "ProductSKU", "FK_product" );
	}

	function categories(){
		return belongsToMany( "ProductCategory", "cbc_lookups_products_categories",  "FK_product", "FK_category" );
	}

	function media(){
		return hasMany( "ProductMedia", "FK_product" );
	}

}