/**
* A cool Customer entity
*/
component quick table="cbc_users"extends="BaseCBCommerceEntity" accessors="true"{
        
    // Persistent column properties
    property name="firstName";
    property name="lastName";
    property name="emailName";
    property name="password";
    property name="primaryPhone";
    property name="secondaryPhone";


    function addresses(){
        return hasMany( "CustomerAddress", "FK_user" );
    }

    function roles(){
        return belongsToMany( "UserRole" , "lookups_users_roles", "FK_user", "FK_role" );
    }

    function explicitPermissions(){
        return belongsToMany( "UserPermission" , "lookups_users_explicitPermissions", "FK_user", "FK_permission" );
    }

    return carts(){
        return hasMany( "Cart", "FK_user" );
    }
    
    function orders(){
        return hasMany( "Order", "FK_user" );
    }
}

