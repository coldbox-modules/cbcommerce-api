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
        return item(
            activeEntity.getParent(),
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