component extends="BaseModelTransformer"{
 
    
    function init(){
        arrayAppend( 
            variables.defaultIncludes,
            [
                "media",
                "isActive"
            ],
            true
        );

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

    function includeMedia( activeEntity ){

        var filteredMedia = activeEntity.media().where( 'isActive', 1 )
                .orderBy( 'displayOrder', 'ASC')
                .orderBy( 'createdTime', 'ASC' );

        return collection(
            filteredMedia.getResults(),
            wirebox.getInstance( "MediaTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }
}