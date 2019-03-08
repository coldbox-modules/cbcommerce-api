component extends="BaseModelTransformer"{

    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "product",
                "virtualSKUs",
                "consignor",
                "consignmentBatch"
            ],
            true
        );

        arrayAppend( 
            variables.defaultIncludes,
            [
                "onHand",
                "media",
                "condition",
                "options",
                "subCondition"
            ],
            true
        );

        return this;
    }

    function transform( activeEntity ){
        var memento = super.transform( activeEntity );
        return memento;
    }


    function includeOnHand( activeEntity ){

        return item(
            wirebox.getInstance( "InventoryLocationStock@cbCommerce" )
                    .where( "FK_sku", activeEntity.getId() )
                    .sum( 'available' ),
            function( available ){
                return javacast( "int", len( available ) ? available : 0 );
            }
        );
    }

    function includeOptions( activeEntity ){
        return collection(
            activeEntity.getOptions(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( "SimpleSerializer@cffractal")
        );
    }

    function includeConsignor( activeEntity ){
        return item(
            activeEntity.getConsignor(),
            wirebox.getInstance( "UserTransformer@cbCommerce" )
        );
    }

    function includeConsignmentBatch( activeEntity ){
        return item(
            activeEntity.getConsignmentBatch(),
            wirebox.getInstance( "UserTransformer@cbCommerce" )
        );
    }

    function includeInventory( activeEntity ){
        return collection(
            activeEntity.getInventory(),
            wirebox.getInstance( "InventoryLocationStockTransformer@cbCommerce" )
        );
    }

    function includeProduct( activeEntity ){
        return item(
            activeEntity.getProduct(),
            wirebox.getInstance( "ProductTransformer@cbCommerce" )
        )
    }

    function includeVirtualSKUs( activeEntity ){
        return collection(
            activeEntity.getVirtualSKUs(),
            wirebox.getInstance( "BaseModelTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        )
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

    function includeCondition( activeEntity ){
        return item(
            activeEntity.getCondition(),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" )
        );
    }

    function includeSubCondition( activeEntity ){
        return item(
            activeEntity.getSubCondition(),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" )
        );
    }
}