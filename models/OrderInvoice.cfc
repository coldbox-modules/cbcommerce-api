/**
* Order Invoices Model
*/
component   table="cbc_orderInvoices" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{ 
	// The internal invoice number
	property name="internalId";
	// The PO or reference number
	property name="externalId";

	// Textual fields
	property name="terms" type="string" default="";
	property name="notes" type="string" default="";

	//Foreign Keys
	property name="FK_wishlist";

   function order(){
	   return hasMany( "Order@cbCommerce", "FK_invoice" );
   }

   function wishlist(){
	   return belongsTo( "Wishlist@cbCommerce", "FK_wishlist" );
   }
	
}