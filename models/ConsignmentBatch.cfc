/**
* cboxCommerce Consignment Batch Model
*/
component table="cbc_consignmentBatches"  
        extends="BaseCBCommerceEntity"
        accessors="true"
        quick
{
    property name="externalId" type="string" default="";
    property name="summary" type="string" default="";
    property name="description" type="string" default="";
    property name="consignorPercent" type="numeric" default=0;
    property name="cleaningHourlyRate" type="numeric" default=0;
    property name="repairHourlyRate" type="numeric" default=0;

	//Foreign Keys
	property name="FK_consignor";
	
	function consignor(){
		return belongsTo( "User@cbCommerce", "FK_consignor" );
	}

	function skus(){
		return hasMany( "ProductSKU@cbCommerce", "FK_consignmentBatch" );
	}


	function delete(){
        skus().sync([]);
		return super.delete();
	}

}