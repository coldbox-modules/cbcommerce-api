/**
* cboxCommerce Order Object
*/
component   table="cbc_orders" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   

    property name="approvaltime" type="date";
    property name="fulfilledTime" type="date";
    property name="subtotal" type="numeric";
    property name="shipping" type="numeric";
    property name="fees" type="numeric";
    property name="tax" type="numeric";
    property name="discount" type="numeric";
    property name="total" type="numeric";
    property name="paidInFull" type="date";

	function customer(){
        return belongsTo( "User", "FK_user" );
    }

    function shippingAddress(){
        return belongsTo( "CustomerAddress", "FK_shippingAddress" );
    }

    function billingAddress(){
        return belongsTo( "CustomerAddress", "FK_billingAddress" );
    }
}

