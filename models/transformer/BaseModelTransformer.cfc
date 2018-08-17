component extends="cffractal.models.transformers.AbstractTransformer" accessors="true"{
    property name="dateUtil" inject="DateFormatUtil@cbc";
    property name="defaultIncludes";
    property name="availableIncludes";
    property name="collectionSerializer";

    variables.defaultIncludes = [
    	"createdTime",
    	"modifiedTime"
    ];
    variables.availableIncludes = [
        "isActive"
    ];

    variables.collectionSerializer = 'ResultsMapSerializer@cffractal';

    function transform( activeEntity ) {
    	
    	if( isNull( activeEntity ) ) return {};
        
        var excludes = duplicate( variables.availableIncludes );
        
        arrayAppend( excludes, variables.defaultIncludes, true );

        var memento = activeEntity.getMemento();

        memento.keyArray().each( function( key ){
            if( excludes.contains( key ) ){
                structDelete( memento, key );
            }
        } );

        return memento;
    
    }

    function includeCreatedTime( activeEntity ){
        return item( 
            activeEntity.getCreatedTime(),
            function( time ){
                return dateUtil.toISO8601( time );
            }
        );
    }

    function includeModifiedTime( activeEntity ){
        return item( 
            activeEntity.getModifiedTime(),
            function( time ){
                return dateUtil.toISO8601( time );
            }
        );   
    }

    function includeIsActive( activeEntity ){
        return item( 
            activeEntity.getIsActive(),
            function( isActive ){ return javacast( "boolean", isActive ); }
        );
    }

}