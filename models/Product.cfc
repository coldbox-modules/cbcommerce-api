/**
* cboxCommerce default Product Object
*/
component   table="cbc_products" 
			extends="quick.models.BaseEntity" 
			accessors="true"
			implements="cbc.models.interfaces.iProduct"
			quick
{
    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties

	
}