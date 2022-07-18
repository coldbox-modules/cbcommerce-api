/**
* cboxCommerce Order Item Object
*/
component   table="cbc_orderShipments"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="quantity" type="numeric";
	property name="carrierReferenceNumber" type="string";

	//Foreign Keys
	property name="FK_order";
	property name="FK_inventoryLocation";
	property name="FK_deliveryMethod";

	function order(){
		return belongsTo( "Order", "FK_order" );
	}

	function inventoryLocation(){
		return belongsTo(  "InventoryLocation@cbCommerce", "FK_inventoryLocation" );
	}

	function deliveryMethod(){
		return belongsTo( "DeliveryMethod@cbcommerce", "FK_deliveryMethod" );
	}

}