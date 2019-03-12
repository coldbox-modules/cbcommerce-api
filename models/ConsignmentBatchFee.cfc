/**
* cboxCommerce Consignment Batch Fee Model
*/
component table="cbc_consignmentBatchFees"  
        extends="BaseCBCommerceEntity"
        accessors="true"
        quick
{
	property name="amount" type="numeric";
    property name="notes" type="string" default="";
    property name="isPaid" type="boolean" default=0;

	//Foreign Keys
	property name="FK_batch";
	property name="FK_feeType";
	property name="FK_createdBy";

	function batch(){
		return belongsTo( "ConsignmentBatch@cbCommerce", "FK_batch" );
	}

	function feeType(){
		return belongsTo( "ConsignmentFeeType@cbCommerce", "FK_feeType" );
	}

	function createdBy(){
		return belongsTo( "User@cbCommerce", "FK_createdBy" );
	}

	this.constraints = {
		amount : { required : true },
		FK_batch : { required : true },
        FK_feeType : { required : true },
        FK_createdBy : { required : true }
	};

}