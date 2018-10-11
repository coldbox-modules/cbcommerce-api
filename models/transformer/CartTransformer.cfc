component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
            ],
            true
        );

        return this;
    }

}