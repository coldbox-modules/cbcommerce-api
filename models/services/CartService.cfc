component extends="BaseQuickEntityService" singleton{
    property name="cookieStorage" inject="CookieStorage@cbCommerce";
    property name="auth" inject="authenticationService@cbauth";
    property name="dateUtil" inject="DateFormatUtil@cbCommerce";
    property name="fractal" inject="Manager@cffractal";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="Cart@cbCommerce"{}
    function skuEntity() provider="ProductSKU@cbCommerce"{}

    /**
     * Retreives the current cart contents
     */
    struct function getActiveCart(){
        return ensureCart();
    }

    Cart function addItem( required string itemId, quantity = 1 ){
        arguments.append = true;
        return updateItem( argumentCollection = arguments );
    }

    /**
     * Adds an item to the cart
     *
     * @itemId the ProductSKU to add
     * @quantity the quanitity of items to add (default 1)
     * @append boolean Whether to append or replace the quantity
     */
    Cart function updateItem( required string itemId, quantity=1, append=false ){
        var cart = ensureCart();
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
                if( append ){
                    item.quantity += appendQuantity;
                } else {
                    item.quantity = appendQuantity;
                }
                item.updated = dateUtil.toISO8601( now() );
            }
        } );

        if( !itemExists ){
            var serializedProduct = fractal.builder()
				.item( sku.getProduct() )
				.withTransformer( "ProductTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = '/store/api/v1/products/' & transformed[ "id" ];
						return transformed;
					}
				)
                .convert();
            if( arrayLen( serializedProduct.media ) ){
                serializedProduct[ "image" ] = serializedProduct.media[ 1 ];
            }

            structDelete( serializedProduct, "media" );

            var serializedSKU = fractal.builder()
				.item( sku )
				.withTransformer( "ProductSKUTransformer@cbCommerce" )
                .convert();

            if( arrayLen( serializedSKU.media ) ){
                serializedSKU[ "image" ] = serializedSKU.media[ 1 ];
            }

            structDelete( serializedSKU, "media" );


            var newItem = {
                "added"    :  dateUtil.toISO8601( now() ),
                "updated"  :  dateUtil.toISO8601( now() ),
                "product"  :  serializedProduct,
                "sku"      :  serializedSKU,
                "quantity" : arguments.quantity
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
    Cart function removeItem( required string itemId, quantity=1 ){
        var cart = ensureCart();

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

            if( item.quantity <= 0 ){
                deleteIndex = i;
                break;
            }
        }

        if( deleteIndex > 0 ){
            arrayDeleteAt( items, deleteIndex );
        }

        return cart.setContents( contents );

    }


    private function ensureCart(){
        var cartId = cookieStorage.getVar( "cartId" );

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

        cookieStorage.setVar( "cartId", activeCart.getId() );

        return activeCart;


    }

}