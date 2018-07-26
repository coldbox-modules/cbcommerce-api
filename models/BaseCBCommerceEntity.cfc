component extends="quick.models.BaseEntity"{

    //default entity properties
    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties
    property name="isActive";
    property name="createdTime";
    property name="modifiedTime";
    property name="designation";

}