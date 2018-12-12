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
                "items"
            ],
            true
        );

        return this;
    }

    function includeItems( activeEntity ){
        return collection(
            activeEntity.getItems(),
            wirebox.getInstance( "WishlistItemTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

}