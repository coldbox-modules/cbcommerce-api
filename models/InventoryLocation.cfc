/**
* cboxCommerce Inventory Location Object
*/
component   table="cbc_inventoryLocations" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   
	property name="name" type="string" default="";
	property name="description" type="string" default="";
	property name="address1" type="string" default="";
	property name="address2" type="string" default="";
	property name="city" type="string" default="";
	property name="province" type="string" default="";
	property name="postalCode" type="string" default="";
	property name="country" type="string" default="";

	function inventory(){
		return hasMany( "InventoryLocationStock", "FK_inventoryLocation" );
	}
}