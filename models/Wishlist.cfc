/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlists" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			quick
{
   property name="name" type="string";
	property name="isDefault" type="boolean" default=0;
	property name="isPublic" type="boolean" default=0;

   //Foreign Keys
	property name="FK_user";

   function user(){
	   return belongsTo( "User@cbCommerce", "FK_user" );
   }

   function items(){
	   return hasMany( "WishlistItem@cbCommerce", "FK_wishlist" );
   }

}