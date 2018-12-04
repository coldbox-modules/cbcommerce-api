/**
* cboxCommerce default Product Object
*/
component   table="cbc_virtualSKUs" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   	
	//persistent properties
	property name="location";

	//Foreign Keys
	property name="FK_sku";

	function sku(){
		return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
	}
	

}