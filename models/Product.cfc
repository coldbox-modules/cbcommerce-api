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
	property name="manufacturer" type="string" default="";
	// need to scope this as a bit until quick fixes the boolean handling
	property name="hasOptions" type="numeric" default=0;
	property name="requiredOptions" type="string" default="{}";
	property name="sortOrder" type="numeric" default=0;
	// an external reference id used for syncing data between systems
	property name="externalId" type="string";

	this.constraints = {
		name = { required : true },
		hasOptions = { required : true, type : "numeric" },
		requiredOptions = { required : true, type : "string" }
	};

	// Relationships
	function skus(){
		return hasMany( "ProductSKU@cbCommerce", "FK_product" );
	}

	function categories(){
		return belongsToMany( "ProductCategory@cbCommerce", "cbc_lookups_products_categories",  "FK_product", "FK_category" );
	}

	function media(){
		return hasMany( "ProductMedia@cbCommerce", "FK_product" );
	}

}