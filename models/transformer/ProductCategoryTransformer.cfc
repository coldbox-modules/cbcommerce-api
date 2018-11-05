component extends="BaseModelTransformer"{
 
    
    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "products",
                "parent",
                "children"
            ],
            true
        );

        return this;
    }

    function includeProducts( activeEntity ){
        return collection(
            activeEntity.getProducts(),
            wirebox.getInstance( "ProductTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeParent( activeEntity ){
        return item(
            activeEntity.getParent(),
            wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" )
        );
    }

    function includeChildren( activeEntity ){
        return collection(
            activeEntity.getChildren(),
            wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }
}