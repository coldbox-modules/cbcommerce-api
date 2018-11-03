component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "product",
                "options"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
                "order"
            ],
            true
        );

        return this;
    }

    function includeOptions( activeEntity ){
        return item(
            activeEntity.getSKU(),
            function( sku ){
                return deserializeJSON( sku.getOptions() );
            }
        );
    }

    function includeOrder( activeEntity ){
        return item(
            activeEntity.getOrder(),
            wirebox.getInstance( "OrderTransformer@cbCommerce" )
        );
    }

    function includeProduct( activeEntity ){
        return item(
            activeEntity.getSKU().getProduct(),
            wirebox.getInstance( "ProductTransformer@cbCommerce" )
        );
    }


}