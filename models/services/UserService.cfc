component extends="BaseQuickEntityService" singleton{
	property name="encryptionService" inject="EncryptionService@cbCommerce";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="User@cbCommerce"{}

    /**
     * CBAuth Implementation Methods
     */

    /**
     * @username the email address of the user for authentication
     * @password the password to validate
     */
    public function isValidCredentials( required string username, required string password ){
        var user = retrieveUserByUsername( arguments.username );
        if( !isNull( isNull ) ){
            return encryptionService.bcryptMatches( arguments.password, user.getPassword() );
        }
    }

    public function retrieveUserByUsername( required string username ){
        return newEntity().newQuery().where( 'email', arguments.username ).first();
    }

    public function retrieveById( required string id ){
        return newEntity.find( arguments.id );
    }

}