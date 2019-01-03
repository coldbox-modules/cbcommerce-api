component extends="BaseModelTransformer"{

    function init(){
        arrayAppend( 
            variables.availableIncludes,
            [
                "product",
                "virtualSKUs",
                "consignee",
                "subCondition"
            ],
            true
        );

        arrayAppend( 
            variables.defaultIncludes,
            [
                "onHand",
                "media",
                "condition"
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
        var consignee = activeEntity.getConsignee();
        return item(
            consignee.isLoaded() ? consignee : javacast( "null", 0 ),
            wirebox.getInstance( "UserTransformer@cbCommerce" )
        );
    }

    function includeInventory( activeEntity ){
        var inventory = wirebox.getInstance( "InventoryLocationStock@cbCommerce" ).newQuery().where( 'FK_sku', activeEntity.getId() );
        
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
        var condition = activeEntity.getCondition();
        return item(
            condition.isLoaded() ? condition : javacast( "null", 0 ),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" )
        );
    }

    function includeSubCondition( activeEntity ){
        var condition = activeEntity.getSubCondition();
        return item(
            condition.isLoaded() ? condition : javacast( "null", 0 ),
            wirebox.getInstance( "ProductConditionTransformer@cbCommerce" )
        );
    }
}