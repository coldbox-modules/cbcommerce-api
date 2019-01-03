component extends="BaseModelTransformer"{
 
    
    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "parent",
                "children"
            ],
            true
        );

        return this;
    }

    function includeParent( activeEntity ){
        var parent = activeEntity.getParent()
        return item(
            parent.isLoaded() ? parent : javacast( "null", 0 ),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" )
        );
    }

    function includeChildren( activeEntity ){
        return collection(
            activeEntity.getChildren(),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }
}