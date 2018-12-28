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
    property name="isFeatured" type="boolean" default=0;
	// need to scope this as a bit until quick fixes the boolean handling
	property name="hasOptions" type="numeric" default=0;
	property name="requiredOptions" type="string" default="{}";
	property name="displayOrder" type="numeric" default=0;
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

	function reviews(){
		return hasMany( "ProductReview@cbCommerce", "FK_product");
	}

    function scopeHasUsedSKU( query ){
        return query.whereExists(
            function( subQuery ){
				subQuery.from( 'cbc_SKUs' )
						.whereColumn( 'cbc_SKUs.FK_product', '=', 'cbc_products.id' )
                        .join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' )
                        .where( 'cbc_productConditions.name', '!=', 'New' );
            }
        );
	}
	
	function filterSearch(
		required struct searchCollection, 
		required QueryBuilder builder
	 ){

	 }

}