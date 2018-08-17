/**
* cboxCommerce default Product Object
*/
component   table="cbc_skus" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   
	// Persistent column properties
	property name="isVirtual" type="boolean" default="false";
	property name="isConsigned" type="boolean" default="false";
	property name="cost" type="numeric";
	property name="basePrice" type="numeric";
	property name="minimumPrice" type="numeric";
	property name="MSRP" type="numeric";
	property name="discontinueOn" type="date";
	property name="packagedWeight" type="numeric";
	property name="packagingX" type="numeric";
	property name="packagingY" type="numeric";
	property name="packagingZ" type="numeric";
	property name="options" type="string" default="{}";
	property name="condition" type="string" default="New";
	property name="subCondition" type="string";
	property name="conditionDescription" type="string";

	function product(){
		return belongsTo( "Product@cbc", "FK_product" );
	}

	function images(){
		return hasMany( "ProductSkuMedia@cbc", "FK_sku" );
	}

	function virtualSKUs(){
		return hasMany( "VirtualSKU@cbc", "FK_sku" );
	}

	function consignee(){
		return belongsTo( "User@cbc", "FK_consignee" );
	}
	
}