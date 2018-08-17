/**
* A cool Customer entity
*/
component quick table="cbc_users"extends="BaseCBCommerceEntity" accessors="true"{
    property name="bcrypt" inject="Bcrypt@BCrypt" persistent="false";
        
    // Persistent column properties
    property name="firstName";
    property name="lastName";
    property name="emailName";
    property name="password";
    property name="primaryPhone";
    property name="secondaryPhone";


    function addresses(){
        return hasMany( "CustomerAddress@cbc", "FK_user" );
    }

    function roles(){
        return belongsToMany( "UserRole@cbc" , "lookups_users_roles", "FK_user", "FK_role" );
    }

    function explicitPermissions(){
        return belongsToMany( "UserPermission@cbc" , "lookups_users_explicitPermissions", "FK_user", "FK_permission" );
    }

    function carts(){
        return hasMany( "Cart@cbc", "FK_user" );
    }
    
    function orders(){
        return hasMany( "Order@cbc", "FK_user" );
    }
}

