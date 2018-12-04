/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productSKUMedia"  
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="isPrimary" type="boolean" default=0;
	property name="displayOrder" type="numeric" default=0;

	//Foreign Keys
	property name="FK_media";
	property name="FK_sku";
	
	function mediaItem(){
		return belongsTo( "Media@cbCommerce", "FK_media" );
	}

	function sku(){
		return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
	}

}