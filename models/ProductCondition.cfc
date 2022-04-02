/**
* cboxCommerce default Product Category Object
*/
component table="cbc_productConditions"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";

	//Foreign Keys
	property name="FK_parent";

    // Relationships
	function parent(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_parent");
    }

	function children(){
		return hasMany( "ProductCondition@cbCommerce", "FK_parent");
	}
}