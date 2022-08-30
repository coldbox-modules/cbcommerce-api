/**
* A cool Customer entity
*/
component quick table="cbc_userPermissions"extends="BaseCBCommerceEntity" accessors="true"{

    // Persistent column properties
    property name="prefix" type="string";
    property name="suffix" type="string";

    function roles(){
        return belongsToMany( "UserRole@cbCommerce", "cbc_lookups_roles_permissions", "FK_permission", "FK_user_role" );
    }

    function explicitAssignments(){
        return belongsToMany( "User@cbCommerce" , "cbc_lookups_users_explicitPermissions", "FK_permission", "FK_user" );
    }


}

