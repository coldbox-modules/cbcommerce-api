component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "href"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
                "variations"
            ],
            true
        );

        return this;
    }

    function includeHref( activeEntity ){
        return item(
            activeEntity,
            function( entity ){ return entity.url(); }
        );
    }

}