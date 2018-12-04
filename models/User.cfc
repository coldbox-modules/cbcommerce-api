/**
* A cool Customer entity
*/
component quick table="cbc_users" extends="BaseCBCommerceEntity" accessors="true"{
    property name="encryptionService" inject="EncryptionService@cbCommerce" persistent="false";
        
    // Persistent column properties
    property name="firstName";
    property name="lastName";
    property name="email";
    property name="password";
    property name="primaryPhone";
    property name="secondaryPhone";


    function addresses(){
        return hasMany( "CustomerAddress@cbCommerce", "FK_user" );
    }

    function roles(){
        return belongsToMany( "UserRole@cbCommerce" , "cbc_lookups_users_roles", "FK_user", "FK_user_role" );
    }

    function explicitPermissions(){
        return belongsToMany( "UserPermission@cbCommerce" , "cbc_lookups_users_explicitPermissions", "FK_user", "FK_permission" );
    }

    function carts(){
        return hasMany( "Cart@cbCommerce", "FK_user" );
    }
    
    function orders(){
        return hasMany( "Order@cbCommerce", "FK_user" );
    }

    function setPassword( value ) {
        return assignAttribute( "password", encryptionService.bCrypt( value ) );
    }

}

