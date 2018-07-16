/**
* A cool Customer entity
*/
component quick table="cboxCommerce_customerAddresses"{

    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties
    property name="isActive" column="";
    property name="createdTime";
    property name="modifiedTime";
    property name="designation";

    function customer(){
        return belongsTo( "Customer", "FK_customer" );
    }
   
   

}

