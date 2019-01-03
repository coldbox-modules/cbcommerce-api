/**
* cboxCommerce default Product Object
*/
component   table="cbc_productReviews" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   

	
	property name="isPublished" type="numeric";
	property name="rating" type="numeric";
	property name="relevancyScore" type="numeric";
	property name="comment" type="string" default="";
	
	//Foreign Keys
	property name="FK_user";
	property name="FK_product";
	property name="FK_sku";


	this.constraints = {
		FK_user = { required : true },
		FK_product = { required : true },
		rating = { required : true, type : "numeric" }
	};
	

	function user(){
		return belongsTo( "User@cbCommerce", "FK_user" );
	}

	function product(){
		return belongsTo( "Product@cbCommerce", "FK_product" );
	}

	function sku(){
		return hasMany( "ProductSku@cbCommerce", "FK_sku" );
	}
	
}