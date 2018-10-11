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
	property name="terms";
	property name="notes";

   function order(){
	   return hasMany( "Order@cbc", "FK_invoice" );
   }

   function wishlist(){
	   return belongsTo( "Wishlist@cbc", "FK_wishlist" );
   }
	
}