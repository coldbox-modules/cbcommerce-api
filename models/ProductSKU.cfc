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
	property name="cost" type="numeric";
	property name="basePrice" type="numeric";
	property name="minimumPrice" type="numeric";
	property name="MSRP" type="numeric";
	property name="discontinueOn" type="date";
	property name="packagedWeight" type="numeric";
	property name="packagingX" type="numeric";
	property name="packagingY" type="numeric";
	property name="packagingZ" type="numeric";
	property name="options" type="string" default="{}";
	property name="conditionDescription" type="string";
	property name="sortOrder" type="numeric" default=0;
	
	// an external reference id used for syncing data between systems
	property name="modelNumber" type="string";
	property name="externalId" type="string";
	
	//Foreign Keys
	property name="FK_product";
	property name="FK_consignee";
	property name="FK_condition";
	property name="FK_subCondition";
	

	function product(){
		return belongsTo( "Product@cbCommerce", "FK_product" );
	}

	function media(){
		return hasMany( "ProductSkuMedia@cbCommerce", "FK_sku" );
	}

	function virtualSKUs(){
		return hasMany( "VirtualSKU@cbCommerce", "FK_sku" );
	}

	function consignee(){
		return belongsTo( "User@cbCommerce", "FK_consignee" );
	}

	function condition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_condition" );
	}

	function subCondition(){
		return belongsTo( "ProductCondition@cbCommerce", "FK_subCondition" );
	}
	
	/**
	 * Pre-save Interception
	 */
	function preSave(){
		if( !isSimpleValue( variables.options ) ){
			setOptions( variables.options );
		}
	}

	function getOptions(){
		if( isSimpleValue( variables.options ) ){
			assignAttribute( retrieveAliasForColumn( 'options' ), deserializeJSON( variables.options ) );
		}
		return variables.options;
	}

	function setOptions( any options ){

		if( !isSimpleValue( arguments.options ) ){
			arguments.options = serializeJSON( arguments.options );
		}

		assignAttribute( retrieveAliasForColumn( 'options' ), arguments.options );
	}
	
}