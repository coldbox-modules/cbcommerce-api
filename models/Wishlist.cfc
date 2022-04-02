/**
* cboxCommerce Wishlist Entity
*/
component   table="cbc_wishlists"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
   property name="name" type="string";
	property name="description" type="string";
	property name="isDefault" type="boolean" default=0;
	property name="isPublic" type="boolean" default=0;

   //Foreign Keys
	property name="FK_user";

	function onDIComplete(){
		super.onDIComplete();
		arrayAppend(
            this.memento.defaultIncludes,
            [
                "items"
            ],
            true
        );
	}

   function user(){
	   return belongsTo( "User@cbCommerce", "FK_user" );
   }

   function items(){
	   return hasMany( "WishlistItem@cbCommerce", "FK_wishlist" );
	}

	function delete(){
		this.getItems().each( function( itemEntity ){
			itemEntity.delete();
		} );
		return super.delete();
	}

}