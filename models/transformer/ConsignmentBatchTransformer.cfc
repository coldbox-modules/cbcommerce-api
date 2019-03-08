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
                "skus",
                "consignor"
            ],
            true
        );

        return this;
    }

    function includeSKUs( activeEntity ){
        return collection(
            activeEntity.getSKUs(),
            wirebox.getInstance( "ProductSKUTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeConsignor( activeEntity ){
        return item(
            activeEntity.getConsignor(),
            wirebox.getInstance( "UserTransformer@cbCommerce" )
        )
    }

}