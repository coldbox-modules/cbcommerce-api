/**
* User Role Entity
*/
component quick table="cbc_userRoles"extends="BaseCBCommerceEntity" accessors="true"{
    
    // Persistent column properties
    property name="name";

    function users(){
        return belongsToMany( "User@cbc" , "lookups_users_roles", "FK_role", "FK_user" );
    }

    function permissions(){
        return belongsToMany( "UserPermission@cbc", "lookups_roles_permissions", "FK_role", "FK_permission" );
    }


	
}

