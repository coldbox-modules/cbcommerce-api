/**
* cboxCommerce Order Item Object
*/
component   table="cbc_orderItems" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{       
    // Persistent column properties
    property name="isVirtual" type="boolean" default=0;
    property name="quantityOrdered" type="numeric" default=1;
    property name="quantityCancelled" type="numeric" default=0;
    property name="quantityRefunded" type="numeric" default=0;
    property name="quantityDownloaded" type="numeric" default=0;
    property name="originalPrice" type="numeric";
    property name="originalCost" type="numeric";
    property name="productSnapshot" type="string";

    //Foreign Keys
	property name="FK_order";
	property name="FK_sku";

    function order(){
        return belongsTo( "Order@cbCommerce", "FK_order" );
    }

    function sku(){
        return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
    }

}

