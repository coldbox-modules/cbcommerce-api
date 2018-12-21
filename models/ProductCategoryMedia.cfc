/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productCategoryMedia"  
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="isPrimary" type="boolean" default=0;
	property name="displayOrder" type="numeric" default=0;

	//Foreign Keys
	property name="FK_media";
	property name="FK_category";
	
	function mediaItem(){
		return belongsTo( "Media@cbCommerce", "FK_media" );
	}

	function category(){
		return belongsTo( "ProductCategory@cbCommerce", "FK_category" );
	}

}