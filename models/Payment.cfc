/**
* cboxCommerce Payment Object
*/
component   table="cbc_payments"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
    property name="externalTransactionId" type="string" default="";
    property name="amount" type="numeric";
    property name="comment" type="string" default="";
    property name="lastFour" type="numeric";
    property name="paymentMethod" type="string";

    //Foreign Keys
	property name="FK_order";

    this.constraints = {
		externalTransactionId : { required : true },
        amount : { required : true },
		paymentMethod : { required: true }
	};

    function order(){
        return belongsTo( "Order@cbCommerce", "FK_order" );
    }

}