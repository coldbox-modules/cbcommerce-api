component extends="BaseModelTransformer"{

    function init(){
    	arrayAppend( 
            variables.defaultIncludes,
            [
                "media",
                "createdTime",
                "isActive"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
                "skus",
                "categories"
            ],
            true
        );

        return this;
    }

    function transform( activeEntity ){
        var memento = super.transform( argumentCollection=arguments );
        memento.requiredOptions = len( memento.requiredOptions) ? deserializeJSON( memento.requiredOptions ) : {};
        return memento;
    }

    function includeSkus( activeEntity ){
        return collection(
            activeEntity.getSkus(),
            wirebox.getInstance( "ProductSKUTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeCategories( activeEntity ){
        return collection(
            activeEntity.getCategories(),
            wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeMedia( activeEntity ){

        var filteredMedia = activeEntity.media().where( 'isActive', true )
                .orderBy( 'isPrimary', 'DESC')
                .orderBy( 'displayOrder', 'ASC')
                .orderBy( 'createdTime', 'ASC' );

        return collection(
            filteredMedia.getResults(),
            wirebox.getInstance( "MediaTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

}