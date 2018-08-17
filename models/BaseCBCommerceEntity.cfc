component extends="quick.models.BaseEntity"{

    //default entity properties
    property name="keyType" inject="UUID@quick" persistent="false";
    
    // Persistent column properties
    property name="id" type="string";
    property name="isActive" type="boolean" default=true;
    property name="createdTime" type="date" default="#now()#";
    property name="modifiedTime" type="date" default="#now()#";

}