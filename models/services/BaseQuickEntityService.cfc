component{

    function getUtil() provider="coldbox.system.core.Util"{}

    /**
	* Performs an abstract search against product entities
	* 
	* @searchCollection 		struct 		The collection of arguments for the search ( e.g. - the public request collection  )
	* @maxrows					[numeric] 	The max rows to be returned ( default=25 )
	* @offset					[numeric] 	The offset for the query ( default=0 )
	* @sortOrder				[numeric] 	The sort for the recordset ( default="createdTime DESC" )
	* @selectList 			    [string]    When passed the query will be transformed to a projection list, which will return an array of structs
	**/
	any function search(
		required searchCollection,
		maxrows = 50,
		offset = 0,
		sortOrder = "createdTime DESC",
		projectionList = ""
	) {

        var entity = newEntity();
        
        var q = entity.query()
                        .limit( maxrows )
                        .offset( offset )
                        .orderBy( 
                            listFirst( sortOrder, " " ), 
                            listLast( sortOrder, " " ) 
                        );
        
        filterCommonSearchArgs( searchCollection, entity, q );

        return {
            "pagination" : {
                "maxrows" : maxrows,
                "offset"  : offset,
                "total"   : q.count()
            },
            "collection"  : q.get().getCollection()
        };        

    }

    /**
     * Filters common search arguments based on the component metadata
     * @searchCollection the search arguments
     * @entity the entity instance
     * @q the active query
     */
    void function filterCommonSearchArgs( searchCollection, entity, q ){
        var md = getUtil().getInheritedMetadata( entity );
        for( var key in searchCollection ){
            if( hasMetaProperty( md, key ) ){
                q.where( key, searchCollection[ key ] );
            } else if( hasMetaFunction( md, key ) ) {
                var fn = q[ key ];
                fn()->where( key, searchCollection[ key ] );
            }
        }
    }

    void function hasMetaProperty( meta, key ){
        return javacast( 
            "boolean", 
            meta.properties.filter(
                function( prop ){
                    return prop[ "name" ] == key
                }
            )
        );
    }


}