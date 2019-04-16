component extends="BaseModelTransformer" accessors="true"{
    property name="activeChildrenOnly" default=true;
    property name="newChildrenOnly" default="false";
    
    function init(){
        arrayAppend( 
            variables.defaultIncludes,
            [
                "media",
                "isActive"
            ],
            true
        );

        arrayAppend( 
            variables.availableIncludes,
            [
                "products",
                "parent",
                "children"
            ],
            true
        );

        return this;
    }

    function includeProducts( activeEntity ){
        return collection(
            activeEntity.getProducts(),
            wirebox.getInstance( "ProductTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeParent( activeEntity ){
        return item(
            activeEntity.getParent(),
            wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" )
        );
    }

    function includeChildren( activeEntity ){
        var q = activeEntity.children().where( 'isActive', 1 );

        if( variables.activeChildrenOnly ){
            q.hasActiveProducts()
        }

        if( variables.newChildrenOnly ){
            q.hasProductInCondition( "New" )
        }
        
        var transformer = wirebox.getInstance( "ProductCategoryTransformer@cbCommerce" );
        
        transformer.setActiveChildrenOnly( variables.activeChildrenOnly );
        transformer.setNewChildrenOnly( variables.newChildrenOnly );
        
        return collection(
            q.orderBy( "displayOrder", "ASC" ).orderBy( 'name', 'ASC' ).getResults(),
            transformer,
            wirebox.getInstance( collectionSerializer )
        );
    }

    function includeMedia( activeEntity ){

        var filteredMedia = activeEntity.media()
                .where( 'isActive', 1 )
                .orderBy( 'isPrimary', 'DESC' )
                .orderBy( 'displayOrder', 'ASC')
                .orderBy( 'createdTime', 'ASC' );

        return collection(
            filteredMedia.getResults(),
            wirebox.getInstance( "MediaTransformer@cbCommerce" ),
            wirebox.getInstance( collectionSerializer )
        );
    }
}