component extends="BaseQuickEntityService" singleton{
    property name="sessionStorage" inject="SessionStorage@cbc";
    property name="cookieStorage" inject="CookieStorage@cbc";
    property name="auth" inject="authenticationService@cbauth";
    property name="dateUtil" inject="DateFormatUtil@cbc";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="Cart@cbc"{}
    function skuEntity() provider="ProductSKU@cbc"{}

    /**
     * Retreives the current cart contents
     */
    struct function getActiveCart(){
        return ensureCart();
    }

    /**
     * Adds an item to the cart
     *
     * @itemId the ProductSKU to add
     * @quantity the quanitity of items to add (default 1)
     */
    Cart function addItem( required string itemId, quantity=1 ){
        var cart = ensureCart();
        appendAuditTrail( cart );
        var sku = skuEntity().find( itemId );

        //take no action if our item was not found
        if( isNull( sku ) ) return cart;

        var contents = cart.getContents();
        var items = contents.items;

        var itemExists = false;

        var appendQuantity = arguments.quantity;

        items.each( function( item ){
            if( item.sku.id == sku.getId() ){
                itemExists = true;
                item.quantity += appendQuantity;
                item.updated = dateUtil.toISO8601( now() );
            }
        } );

        if( !itemExists ){
            var newItem = {
                "added"   :  dateUtil.toISO8601( now() ),
                "updated" :  dateUtil.toISO8601( now() ), 
                "product" :  sku.getProduct.getMemento(),
                "sku"     :  sku.getMemento()
            };
            newItem.sku[ "quantity" ] = appendQuantity;
            arrayAppend( items, newItem );
        }

        return cart.setContents( contents );

    }

    /**
     * Removes an item from the cart
     *
     * @itemId the ProductSKU to remove
     * @quantity the quanitity of items to remove ( default all )
     */
    Cart function removeItem( required string itemId, quantity ){
        var cart = ensureCart();
        appendAuditTrail( cart );

        var contents = cart.getContents();
        var items = contents.items;

        // prevents scope walking within the `each` method
        var skuId = arguments.itemId;
        var removeQuantity = arguments.quantity;

        var deleteIndex = 0;

        for( var i = 1; i <= arrayLen( items ); i++ ){
            var item = items[ i ];
            if( item.sku.id != skuId ) continue;
            item.quantity -= removeQuantity;
            item.updated = dateUtil.toISO8601( now() );

            if( item.quanity <= 0 ){
                deleteIndex = i;
                break;
            }
        }

        if( deleteIndex > 0 ){
            arrayDeleteAt( items, deleteIndex );
        }

        return cart.setContents( contents );

    }

    /**
     * Appends the audit trail information on cart change
     * @cart The Cart entity
     */
    function appendAuditTrail( cart ){
        var audit = getAudit();
        arrayAppend( audit, cart.getContents() );
        cart.setAudit( audit );
    }



    private function ensureCart(){
        var cartId = sessionStorage.getVar( "cartId" );
        
        if( isNull( cartId ) && auth.isLoggedIn() ){
            //check first for an existing active cart
            var activeCart = newEntity().where( 'isActive', 1 ).where( 'FK_user', auth.user().getId() ).first();
        } else if( !isNull( cartId ) ) {
            var activeCart = newEntity().find( cartId );
        }

        if( isNull( activeCart ) ){
            activeCart = newEntity();
            if( auth.isLoggedIn() ){
                activeCart.setUser( auth.user() );
            }
            activeCart.save();
        }

        //persist the user if the cart was created before assigning
        if( auth.isLoggedIn() && isNull( activeCart.getUser() ) ){
            activeCart.setUser( auth.user() );
            activeCart.save();
        }
        
        sessionStorage.setVar( "cartId", activeCart.getId() );

        return activeCart;


    }

}