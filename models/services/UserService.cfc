component extends="BaseQuickEntityService" singleton{
    property name="encryptionService" inject="EncryptionService@cbCommerce";
    property name="roleService" inject="UserRoleService@cbCommerce";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="User@cbCommerce"{}

    /**
	* Overload to base entity search
	*
	* @searchCollection 		struct 		The collection of arguments for the search ( e.g. - the public request collection  )
	* @maxrows					[numeric] 	The max rows to be returned ( default=25 )
	* @offset					[numeric] 	The offset for the query ( default=0 )
	* @sortOrder				[numeric] 	The sort for the recordset ( default="createdTime DESC" )
	* @selectList 			    [string]    When passed the query will be transformed to a projection list, which will return an array of structs
	**/
	public any function search(
		required searchCollection,
		maxrows = 50,
		offset = 0,
		sortOrder = "sortOrder ASC"
	) {

        if( structKeyExists( searchCollection, "role" ) ){
            var searchResults = roleService.newEntity().where( 'name', searchCollection.role ).get();
            var totalRecords = arrayLen( searchResults );
            arguments.maxrows = totalRecords;

        } else {
            return super.search( argumentCollection = arguments );
        }

        return {
            "pagination" : {
                "maxrows" : arguments.maxrows,
                "offset"  : 0,
                "total"   : totalRecords
            },
            "collection"  : searchResults
        };

    }

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
        var located = newEntity().where( 'email', arguments.username ).first();
        if( located.isLoaded() ) return located;
    }

    public function retrieveUserById( required string id ){
        return newEntity().find( arguments.id );
    }

}