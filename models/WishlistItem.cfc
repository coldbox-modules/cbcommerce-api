/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlistItems" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{

   property name="baselinePrice" type="numeric";

   //Foreign Keys
	property name="FK_sku";
	property name="FK_wishlist";

   function sku(){
       return belongsTo( "ProductSKU@cbCommerce", "FK_sku" );
   }

   function wishlist(){
	   return belongsTo( "Wishlist@cbCommerce", "FK_wishlist" );
   }

}