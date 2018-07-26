/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productMedia"  
			accessors="true"
			quick
{
	property name="isPrimary" type="boolean" default="false";
	property name="displayOrder" type="numeric" default=0;
	
	function mediaItem(){
		return belongsTo( "Media", "FK_media" );
	}

	function product(){
		return belongsTo( "Product", "FK_product" );
	}

}