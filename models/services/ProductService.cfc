component extends="BaseQuickEntityService" singleton{
    property name="categoryService" inject="ProductCategoryService@cbCommerce";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="Product@cbCommerce"{}

    /**
	* Performs an abstract search against product entities
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

        if( structKeyExists( searchCollection, "category" ) ){
            var searchResults = categoryService.newEntity().find( searchCollection.category ).getProducts();
            return {
                "pagination" : {
                    "maxrows" : arrayLen( searchResults ),
                    "offset"  : 0,
                    "total"   : arrayLen( searchResults )
                },
                "collection"  : searchResults
            };
        } else {
            return super.search( argumentCollection = arguments );
        }

    }
}