component extends="BaseQuickEntityService" singleton{
    property name="encryptionService" inject="EncryptionService@cbCommerce";
    property name="roleService" inject="UserRoleService@cbCommerce";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="User@cbCommerce"{}

    /**
     * CBAuth Implementation Methods
     */

    /**
     * @username the email address of the user for authentication
     * @password the password to validate
     */
    public boolean function isValidCredentials( required string username, required string password ){
        var user = retrieveUserByUsername( arguments.username );
        if( !isNull( user ) ){
            return encryptionService.bcryptMatches( arguments.password, user.getPassword() );
        } else {
            return false;
        }
    }

    public function retrieveUserByUsername( required string username ){
        return newEntity().where( 'email', arguments.username ).first();
    }

    public function retrieveUserById( required string id ){
        return newEntity().find( arguments.id );
    }

}