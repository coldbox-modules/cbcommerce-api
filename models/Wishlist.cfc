/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlists" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{
   property name="name" type="string";

   function customer(){
	   return belongsTo( "User@cbc", "FK_user" );
   }

   function items(){
	   return hasMany( "WishlistItem@cbc", "FK_wishlist" );
   }

}