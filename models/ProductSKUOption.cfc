/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productSKUOptions"  
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="name" type="string" default="";
	property name="value" type="string" default="";
	property name="displayOrder" type="numeric" default=0;

	//Foreign Keys
	property name="FK_sku";

	function sku(){
		return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
	}

}