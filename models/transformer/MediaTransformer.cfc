component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "src"
            ],
            true
        );

        return this;
    }


    function transform( activeEntity ) {

        if( structKeyExists( activeEntity, "mediaItem" ) ){
            var mediaItem = activeEntity.getMediaItem();
            var memento = mediaItem.getMemento();
            structAppend( memento, activeEntity.getMemento(), true );
            structDelete( memento, "FK_media" );
        } else {
            return super.transform( argumentCollection = arguments );
        }

        structDelete( memento, "fileLocation" );

        var excludes = duplicate( variables.availableIncludes );
        
        arrayAppend( excludes, variables.defaultIncludes, true );

        memento.keyArray().each( function( key ){
            if( excludes.contains( key ) ){
                structDelete( memento, key );
            } else if( ( left( key, 2 ) == "is" || left( key, 3 ) == "has" ) && isNumeric( memento[ key ] ) ){
                memento[ key ] = javacast( "boolean", memento[ key ] );
            }
        } );

        return memento;
        
    }

    function includeSrc( activeEntity ){

        if( structKeyExists( activeEntity, "mediaItem" ) ){
            var mediaItem = activeEntity.getMediaItem();
        } else {
            var mediaItem = activeEntity;
        }

        return item(
            mediaItem,
            function( entity ){ return entity.url(); }
        );
    }

}