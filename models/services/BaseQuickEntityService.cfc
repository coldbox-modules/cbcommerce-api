component{

	/**
	 * Get ColdBox Utility Object
	 */
    function getUtil() provider="coldbox.system.core.util.Util"{}

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
		maxrows = 25,
		offset = 0,
		sortOrder = "createdTime DESC"
	) {

        arguments[ "entity" ] = newEntity();

        var builder = newBuilder( argumentCollection = arguments );

        if( structKeyExists( searchCollection, "sortOrder" ) ){
            arguments.sortOrder = searchCollection.sortOrder;
        }

        builder.limit( maxrows )
                .offset( offset );

        listToArray( arguments.sortOrder ).each( function( orderBy ){
            builder.orderBy(
                listFirst( orderBy, " " ),
                listLast( orderBy, " " )
            );
        } );

        var searchResults = arguments.entity.get();

        structDelete( arguments, "entity" );

        return {
            "pagination" : {
                "page"    : javacast( "int", searchCollection.page ),
                "maxrows" : maxrows,
                "offset"  : offset,
                "total"   : newBuilder( argumentCollection=arguments ).count()
            },
            "collection"  : searchResults
        };

    }

    /**
	* Performs a simple count of results for a give search collection
	*
	* @searchCollection 		struct 		The collection of arguments for the search ( e.g. - the public request collection  )
	**/
	public any function count(
		required searchCollection
	) {

        var builder = newBuilder( searchCollection = searchCollection );
        return builder.count();
    }



    /**
	* @searchCollection 		struct 		The collection of arguments for the search ( e.g. - the public request collection  )
	* @maxrows					[numeric] 	The max rows to be returned ( default=25 )
	* @offset					[numeric] 	The offset for the query ( default=0 )
	* @sortOrder				[numeric] 	The sort for the recordset ( default="createdTime DESC" )
	* @selectList 			    [string]    When passed the query will be transformed to a projection list, which will return an array of structs
	**/
    public QueryBuilder function newBuilder(
		required searchCollection,
		maxrows = 25,
		offset = 0,
        sortOrder = "createdTime DESC",
        entity
    ){

        if( isNull( arguments.entity ) ){
            arguments.entity = newEntity();
        }

        var builder = entity.retrieveQuery();

        filterCommonSearchArgs( searchCollection, entity, builder );

        if( structKeyExists( entity, "filterSearch" ) ){
            entity.filterSearch( searchCollection, builder );
        }

        if( structKeyExists( searchCollection, "isNull" ) ){
            listToArray( searchCollection.isNull ).each( function( nullable ){
                builder.whereNull( nullable );
            } );
        }

        return builder;
    }

    /**
     * Filters common search arguments based on the component metadata
     * @searchCollection the search arguments
     * @entity the entity instance
     * @q the active query
     */
    public void function filterCommonSearchArgs( searchCollection, entity, q ){
        var md = getUtil().getInheritedMetadata( entity );
        for( var key in searchCollection ){
            if( !len( searchCollection[ key ] ) ) continue;
			if( ( left( key, 3 ) == 'has' || left( key, 2 ) == 'is' ) && isBoolean( searchCollection[ key ] ) ){
				searchCollection[ key ] = searchCollection[ key ] ? 1 : 0;
			}
			if( hasMetaProperty( md, key ) ){
                q.where( key, searchCollection[ key ] );
            } else if( hasMetaFunction( md, key ) ) {
                var fn = q[ key ];
                fn().where( key, searchCollection[ key ] );
            }
        }
    }

    public boolean function hasMetaProperty( meta, key ){
        return javacast(
            "boolean",
            arrayLen( meta.properties.filter(
                function( prop ){
                    return prop[ "name" ] == key;
                }
            ) )
        );
    }

    public boolean function hasMetaFunction( meta, key ){

        return javacast(
            "boolean",
            arrayLen(
                arrayFilter(
                    meta.functions,
                    function( fn ){
                        return fn[ "name" ] == key;
                    }
                )
            )
        );
    }
}