/**
* cboxCommerce Order Item Object
*/
component   table="cbc_orderItems"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
    // Persistent column properties
    property name="isVirtual" type="boolean" default=0  casts="BooleanCast@quick";
    property name="quantityOrdered" type="numeric" default=1;
    property name="quantityCancelled" type="numeric" default=0;
    property name="quantityRefunded" type="numeric" default=0;
    property name="quantityDownloaded" type="numeric" default=0;
    property name="originalPrice" type="numeric";
    property name="originalCost" type="numeric";
    property name="productSnapshot" type="string" default="{}";

    //Foreign Keys
	property name="FK_order";
	// property name="FK_sku";

	function instanceReady(){
		arrayAppend(
            this.memento.defaultIncludes,
            [
               "productSnapshot"
            ],
            true
        );
	}

	/**
	 * Pre-save Interception
	 */
	function preSave(){
		if( !isSimpleValue( variables.productSnapshot ) ){
			setProductSnapshot( variables.productSnapshot );
		}
	}

    function order(){
        return belongsTo( "Order@cbCommerce", "FK_order" );
    }

    /**
    * Overloads to property accessors to serialize and deserialize the JSON values
    */

    public struct function getProductSnapshot(){
		return deserializeJSON( variables.productSnapshot );
    }

    function setProductSnapshot( any productSnapshot ){
		variables.productSnapshot = !isSimpleValue( arguments.productSnapshot ) ? serializeJSON( arguments.productSnapshot ) : arguments.productSnapshot;
	}

}