component extends="BaseModelTransformer"{

    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "product",
                "virtualSKUs",
                "consignee"
            ],
            true
        );

        arrayAppend( 
            variables.defaultIncludes,
            [
                "onHand"
            ],
            true
        );

        return this;
    }

    function transform( activeEntity ){
        var memento = super.transform( activeEntity );
        memento.options = len( memento.options) ? deserializeJSON( memento.options ) : {};
        return memento;
    }

    function includeConsignee( activeEntity ){
        return item(
            activeEntity.getConsignee(),
            wirebox.getInstance( "UserTransformer@cbc" )
        );
    }

    function includeInventory( activeEntity ){
        var inventory = wirebox.getInstance( "InventoryLocationStock@cbc" ).newQuery().where( 'FK_sku', activeEntity.getId() );
        
    }

    function includeOnHand( activeEntity ){

        return item(
            wirebox.getInstance( "InventoryLocationStock@cbc" )
                    .where( "FK_sku", activeEntity.getId() )
                    .sum( 'available' ),
            function( available ){
                return javacast( "int", len( available ) ? available : 0 );
            }
        );
    }

    function includeProduct( activeEntity ){
        return item(
            activeEntity.getProduct(),
            wirebox.getInstance( "ProductTransformer@cbc" )
        )
    }

    function includeVirtualSKUs( activeEntity ){
        return collection(
            activeEntity.getVirtualSKUs(),
            wirebox.getInstance( "BaseModelTransformer@cbc" ),
            wirebox.getInstance( collectionSerializer )
        )
    }
}