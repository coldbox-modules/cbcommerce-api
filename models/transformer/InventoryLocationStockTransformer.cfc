component extends="BaseModelTransformer"{
    
    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "location",
                "sku"
            ],
            true
        );

        return this;
    }

    function includeLocation( activeEntity ){
        return item(
            activeEntity.getLocation(),
            wirebox.getInstance( "InventoryLocationTransformer@cbc" )
        );
    }

    function includeSku( activeEntity ){
        return item( 
            activeEntity.getSku(),
            wirebox.getInstance( "ProductSKUTransformer@cbc" )
        );
    }

}