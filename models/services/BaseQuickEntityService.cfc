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
		maxrows = 50,
		offset = 0,
		sortOrder = "createdTime DESC"
	) {

        arguments[ "entity" ] = newEntity();

        var builder = newBuilder( argumentCollection = arguments );
        
        if( structKeyExists( searchCollection, "isNull" ) ){
            listToArray( searchCollection.isNull ).each( function( nullable ){
                builder.whereNull( nullable );
            } );
        }

        builder.limit( maxrows )
                .offset( offset )
                .orderBy(
                    listFirst( sortOrder, " " ),
                    listLast( sortOrder, " " )
                );

        var searchResults = arguments.entity.getEntities();

        structDelete( arguments, "entity" );

        return {
            "pagination" : {
                "maxrows" : maxrows,
                "offset"  : offset,
                "total"   : newBuilder( argumentCollection=arguments ).count()
            },
            "collection"  : searchResults
        };

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
		maxrows = 50,
		offset = 0,
        sortOrder = "createdTime DESC",
        entity
    ){

        if( isNull( arguments.entity ) ){
            arguments.entity = newEntity();
        }

        var builder = entity.newQuery();

        filterCommonSearchArgs( searchCollection, entity, builder );

        if( structKeyExists( entity, "filterSearch" ) ){
            entity.filterSearch( searchCollection, builder );
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
                    return prop[ "name" ] == key
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
                        return fn[ "name" ] == key
                    }
                )
            )
        );
    }
}