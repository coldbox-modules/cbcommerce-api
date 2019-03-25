component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
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