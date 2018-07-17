/**
* A cool Customer entity
*/
component quick table="cbc_customerAddresses" extends="quick.models.BaseEntity" accessors="true"{

    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties
    property name="isActive";
    property name="createdTime";
    property name="modifiedTime";
    property name="designation";

    function customer(){
        return belongsTo( "Customer", "FK_customer" );
    }
   
}

