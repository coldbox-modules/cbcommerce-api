/**
* cboxCommerce default Product Object
*/
component   table="cbc_SKUs" 
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{   
	// Persistent column properties
	property name="isVirtual" type="boolean" default=0;
	property name="isConsigned" type="boolean" default=0;
	property name="allowBackorder" type="boolean" default=0;
    property name="isFeatured" type="boolean" default=0;
	property name="showPricing" type="boolean" default=0;
	property name="summary" type="string" default="";
	property name="description" type="string" default="";
	property name="cost" type="numeric";
	property name="basePrice" type="numeric";
	property name="minimumPrice" type="numeric";
	property name="MAP" type="numeric";
	property name="MSRP" type="numeric";
	property name="discontinueOn" type="date";
	property name="packagedWeight" type="numeric";
	property name="packagingX" type="numeric";
	property name="packagingY" type="numeric";
	property name="packagingZ" type="numeric";
	property name="conditionDescription" type="string";
	property name="displayOrder" type="numeric" default=0;
	
	// an external reference id used for syncing data between systems
	property name="modelNumber" type="string";
	property name="externalId" type="string";
	
	//Foreign Keys
	property name="FK_product";
	property name="FK_consignor";
	property name="FK_condition";
	property name="FK_subCondition";
	property name="FK_consignmentBatch";
	

	function product(){
		return belongsTo( "Product@cbCommerce", "FK_product" );
	}

	function media(){
		return hasMany( "ProductSkuMedia@cbCommerce", "FK_sku" );
	}

	function virtualSKUs(){
		return hasMany( "VirtualSKU@cbCommerce", "FK_sku" );
	}

	function consignor(){
		return belongsTo( "User@cbCommerce", "FK_consignor" );
	}

	function consignmentBatch(){
		return belongsTo( "ConsignmentBatch@cbCommerce", "FK_consignmentBatch" );
	}

	function condition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_condition" );
	}

	function subCondition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_subCondition" );
	}

	function inventory(){
		return hasMany( "InventoryLocationStock@cbCommerce", "FK_sku" );
	}

	function reviews(){
		return hasMany( "ProductSKU@cbCommere", "FK_sku");
	}

	function options(){
		return hasMany( "ProductSKUOption@cbCommerce", "FK_sku" ).orderBy( "displayOrder", "ASC" );
	}

	function delete(){
		options().delete();
		reviews().delete();
		inventory().delete();
		virtualSKUs().delete();
		getMedia().each( function( mediaItem ){
			mediaItem.delete();
		} )
		return super.delete( argumentCollection=arguments );
	}
	

	function scopeWhereUsed( query ){
		return query.join( 'cbc_productConditions', 'cbc_SKUs.FK_condition', '=', 'cbc_productConditions.id' )
            		.where( 'cbc_productConditions.name', '!=', 'New' );
	}
}