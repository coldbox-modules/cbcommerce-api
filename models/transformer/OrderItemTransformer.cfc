component extends="BaseModelTransformer"{

    function init(){

        arrayAppend(
            variables.defaultIncludes,
            [
               "productSnapshot"
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



    function includeOrder( activeEntity ){
        return item(
            activeEntity.getOrder(),
            wirebox.getInstance( "OrderTransformer@cbCommerce" )
        );
    }

    function includeProductSnapshot( activeEntity ){
        return item(
            activeEntity,
            function( orderItem ){
                return orderItem.getProductSnapshot();
            }
        );
    }

    // function includeProduct( activeEntity ){
    //     return item(
    //         activeEntity.SKU().getProduct(),
    //         wirebox.getInstance( "ProductTransformer@cbCommerce" )
    //     );
    // }


}