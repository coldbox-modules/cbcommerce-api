component extends="BaseModelTransformer"{
    
    function init(){

        arrayAppend( 
            variables.defaultIncludes,
            [
                "sku",
                "image"
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

    function includeImage( activeEntity ){
        return item( 
            activeEntity.getSku(),
            function( skuEntity ){
                if( arrayLen( skuEntity.getMedia() ) ){
                    return skuEntity.getMedia()[ 1 ].getMediaItem().url();
                } else if( arrayLen( skuEntity.getProduct().getMedia() ) ) {
                    return skuEntity.getProduct().getMedia()[ 1 ].getMediaItem().url();
                } else {
                    return "";
                }
            }
        ); 
    }

}