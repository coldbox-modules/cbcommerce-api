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
	// need to scope this as a bit until quick fixes the boolean handling
	property name="hasOptions" type="numeric" default=0;
	property name="requiredOptions" type="string" default="{}";

	this.constraints = {
		name = { required : true },
		hasOptions = { required : true, type : "numeric" },
		requiredOptions = { required : true, type : "string" }
	};

	// Relationships
	function skus(){
		return hasMany( "ProductSKU@cbc", "FK_product" );
	}

	function categories(){
		return belongsToMany( "ProductCategory@cbc", "cbc_lookups_products_categories",  "FK_product", "FK_category" );
	}

	function media(){
		return hasMany( "ProductMedia@cbc", "FK_product" );
	}

}