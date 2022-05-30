/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productMedia"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="isPrimary" type="boolean" default=0;
	property name="displayOrder" type="numeric" default=0;

	//Foreign Keys
	property name="FK_media";
	property name="FK_product";

	this.memento = {
		"defaultIncludes" : [
			"id",
			"createdTime",
			"isActive",
			"modifiedTime",
			"isPrimary",
			"displayOrder",
			"mediaItem",
			"FK_product"
		]
	};

	function mediaItem(){
		return belongsTo( "Media@cbCommerce", "FK_media" );
	}

	function product(){
		return belongsTo( "Product@cbCommerce", "FK_product" );
	}

	function delete(){
		var mediaItem = this.getMediaItem();
		// delete our constrained item first
		super.delete();
		return mediaItem.delete();
	}

}