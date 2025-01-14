/**
* cboxCommerce Order Object
*/
component   table="cbc_orders"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{

    property name="approvalTime" type="date";
    property name="fulfilledTime" type="date";
    property name="subtotal" type="numeric";
    property name="shipping" type="numeric";
    property name="fees" type="numeric";
    property name="tax" type="numeric";
    property name="discount" type="numeric";
    property name="total" type="numeric";
    property name="paidInFull" type="date";

    //Foreign Keys
	property name="FK_user";
	property name="FK_shippingAddress";
	property name="FK_billingAddress";
	property name="FK_invoice";
	property name="FK_deliveryMethod";

	function instanceReady(){
		arrayAppend(
			this.memento.defaultIncludes,
			[
				"customer",
                "items",
                "shippingAddress",
                "billingAddress",
                "deliveryMethod"
			],
			true
		);
	}

	function customer(){
        return belongsTo( "User@cbCommerce", "FK_user" );
    }

    function items(){
        return hasMany( "OrderItem@cbCommerce", "FK_order" );
    }

	function payments(){
		return hasMany( "Payment@cbCommerce", "FK_order" );
	}

    function shippingAddress(){
        return belongsTo( "CustomerAddress@cbCommerce", "FK_shippingAddress" );
    }

    function billingAddress(){
        return belongsTo( "CustomerAddress@cbCommerce", "FK_billingAddress" );
    }

    function invoices(){
        return belongsTo( "OrderInvoice@cbCommerce", "FK_invoice" );
    }

    function deliveryMethod(){
        return belongsTo( "DeliveryMethod@cbCommerce", "FK_deliveryMethod" );
    }
}

