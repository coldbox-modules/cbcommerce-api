component extends="BaseModelTransformer"{

    function init(){
    	arrayAppend( 
            variables.defaultIncludes,
            [
                "media",
                "createdTime",
                "isActive",
                "startingPrice"
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

    function includeStartingPrice( activeEntity ){
        return item(
            activeEntity,
            function( product ){
                var sql = "SELECT id, basePrice, MSRP from cbc_SKUs WHERE FK_Product = '" & activeEntity.keyValue() & "' ORDER BY basePrice ASC LIMIT 1"; 
                var q = new query( sql=sql ).execute().getResult();
                return {
                    "SKU" : q.id,
                    "basePrice" : q.basePrice,
                    "MSRP" : q.MSRP
                };
            }
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

        var filteredMedia = activeEntity.media().where( 'isActive', 1 )
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