/**
* cboxCommerce Payment Object
*/
component   table="cbc_payments" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{  
    property name="externalTransactionId" type="string";
    property name="amount" type="numeric";
    property name="comment" type="string";
    property name="lastFour" type="numeric";
    property name="paymentMethod" type="string"; 

    function order(){
        return belongsTo( "Order@cbCommerce", "FK_order" );
    }

}