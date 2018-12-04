/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlists" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{
   property name="name" type="string";

   //Foreign Keys
	property name="FK_user";

   function customer(){
	   return belongsTo( "User@cbCommerce", "FK_user" );
   }

   function items(){
	   return hasMany( "WishlistItem@cbCommerce", "FK_wishlist" );
   }

}