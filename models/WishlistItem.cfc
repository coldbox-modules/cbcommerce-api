/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlistItems" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{

   property name="baselinePrice" type="numeric";

   function sku(){
       return belongsTo( "ProductSKU@cbc", "FK_sku" );
   }

   function wishlist(){
	   return belongsTo( "Wishlist@cbc", "FK_wishlist" );
   }

}