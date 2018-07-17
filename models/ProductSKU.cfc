/**
* cboxCommerce default Product Object
*/
component   table="cbc_skus" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			implements="cbc.models.interfaces.iProductSKU"
			quick
{
    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties

	
}