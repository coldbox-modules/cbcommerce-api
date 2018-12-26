component extends="BaseModelTransformer"{
    
    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "product",
                "sku",
                "user"
            ],
            true
        );

        return this;
    }

    function includeUser( activeEntity ){
        return item( 
            activeEntity.getUser(),
            wirebox.getInstance( "UserTransformerMinimal@cbCommerce" )
        );
    }

    function includeProduct( activeEntity ){
        return item( 
            activeEntity.getProduct(),
            wirebox.getInstance( "ProductTransformer@cbCommerce" )
        );
    }

    function includeSku( activeEntity ){
        return item( 
            activeEntity.getSku(),
            wirebox.getInstance( "ProductSKUTransformer@cbCommerce" )
        );
    }

}