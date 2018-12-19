component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "href"
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

        return memento;
        
    }

    function includeHref( activeEntity ){

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