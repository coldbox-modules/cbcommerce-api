/**
* cboxCommerce Inventory Location Stock Object
*/
component   table="cbc_inventoryLocationStock"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{

	property name="available" type="numeric" default="0";
	property name="unaccounted" type="numeric" default="0";
	property name="countRequired" type="boolean" default=0;
	property name="allowBackorder" type="boolean" default=0;
	property name="FK_sku" type="string";
	property name="FK_inventoryLocation" type="string";

	function sku(){
		return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
	}

	function location(){
		return belongsTo( "InventoryLocation@cbCommerce", "FK_inventoryLocation" );
	}

}