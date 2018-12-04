<cfscript>
    /**
     * Converts any data structure passed in to an array.
     * @param The data to convert.
     * @return The converted array of data.
     */
    public array function normalizeToArray( required any args ) {
        if ( isArray( args ) ) {
            return args;
        }

        if ( structCount( arguments ) > 1 ) {
            arguments[ 1 ] = arguments[ "ARGS" ];
            var keys = arrayFilter( structKeyArray( arguments ), function( key ) {
                return isNumeric( key );
            } );
            arraySort( keys, "numeric" );
            var normalizedArgs = [];
            for ( var key in keys ) {
                arrayAppend( normalizedArgs, arguments[ key ] );
            }
            return normalizedArgs;
        }

        if ( isQuery( args ) ) {
            var arr = [];
            for ( var row in args ) {
                arrayAppend( arr, row );
            }
            return arr;
        }

        if ( isStruct( args ) ) {
            return [ args ];
        }

        if ( args == "" ) {
            return [ "" ];
        }

        return listToArray( args );
    }
</cfscript>