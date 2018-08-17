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
        return belongsTo( "User@cbc", "FK_user" );
    }

    function items(){
        return hasMany( "OrderItem@cbc", "FK_order" );
    }

    function shippingAddress(){
        return belongsTo( "CustomerAddress@cbc", "FK_shippingAddress" );
    }

    function billingAddress(){
        return belongsTo( "CustomerAddress@cbc", "FK_billingAddress" );
    }
}

