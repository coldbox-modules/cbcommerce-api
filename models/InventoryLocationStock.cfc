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
	property name="countRequired" type="boolean" default="false";
	property name="allowBackorder" type="boolean" default="false";

	function sku(){
		return belongsTo( "ProductSKU", "FK_sku" );
	}

	function location(){
		return belongsTo( "InventoryLocation", "FK_inventoryLocation" )
	}

}