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
	   return belongsTo( "User", "FK_user" );
   }

   function items(){
	   return hasMany( "WishlistItem", "FK_wishlist" );
   }

}