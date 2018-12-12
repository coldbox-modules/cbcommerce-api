component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "sku"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [],
            true
        );

        return this;
    }

    function includeSku( activeEntity ){
        return item(
            activeEntity.getSKU(),
            wirebox.getInstance( "ProductSKUTransformer@cbCommerce" )
        );
    }

}