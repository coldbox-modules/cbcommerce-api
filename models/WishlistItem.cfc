/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlistItems" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{

   property name="baselinePrice" type="numeric";
   property name="discountPrice" default="0";
   

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