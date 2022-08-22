component extends="BaseQuickEntityService" singleton{
    property name="cookieStorage" inject="CookieStorage@cbCommerce";
    property name="auth" inject="authenticationService@cbauth";
    property name="dateUtil" inject="DateFormatUtil@cbCommerce";
    //provider for the entity - this provider must exist to use the search() method
    function newEntity() provider="Cart@cbCommerce"{}
    function skuEntity() provider="ProductSKU@cbCommerce"{}

    /**
     * Retreives the current cart contents
     */
    struct function getActiveCart(){
        return ensureCart();
    }

    Cart function addItem( required string itemId, quantity = 1, targetCart ){
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
    Cart function updateItem( required string itemId, quantity=1, append=false, targetCart ){
        if( isNull( arguments.targetCart) ){
        	var cart = ensureCart();
        } else {
        	var cart = arguments.targetCart;
        }

        var sku = skuEntity().find( itemId );

        //take no action if our item was not found
        if( isNull( sku ) ) return cart;

        var contents = cart.getContents();
        var items = contents.items;

        var itemExists = false;

        var appendQuantity = arguments.quantity;

		var itemIndex = items.find( function( item ){ return item.sku.id == sku.getId(); } );

		if( itemIndex ){
			if( append ){
				items[ itemIndex ].quantity += appendQuantity;
			} else {
				items[ itemIndex ].quantity = appendQuantity;
			}
			items[ itemIndex ].updated = dateUtil.toISO8601( now() );
		} else {
			var serializedProduct = sku.getProduct().getMemento(
										includes="href",
										defaults={ "href" : "" },
										mappers={ "href" : function( item, memento ) { return '/cbc/api/v1/products/' & memento[ "id" ]; } }
									);

            if( arrayLen( serializedProduct.media ) ){
                serializedProduct[ "image" ] = serializedProduct.media[ 1 ];
            }

            structDelete( serializedProduct, "media" );

            var serializedSKU = sku.getMemento();

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

		contents.items = items;

        return cart.setContents( contents );

    }

    /**
     * Removes an item from the cart
     *
     * @itemId the ProductSKU to remove
     * @quantity the quanitity of items to remove ( default all )
     */
    Cart function removeItem( required string itemId ){
        var cart = ensureCart();

        var contents = cart.getContents();
        var items = contents.items;

        var deleteIndex = items.find( function( item ){ return item.sku.id == itemId; } );

        if( deleteIndex ){
            arrayDeleteAt( items, deleteIndex );
        }

		contents.items = items;

        return cart.setContents( contents );

    }


    private function ensureCart(){
        var cartId = cookieStorage.get( "cartId" );

        if( isNull( cartId ) && auth.check() ){
            //if user is logged in check first for an existing active cart
            var activeCart = newEntity().where( 'isActive', 1 ).where( 'FK_user', auth.user().getId() ).first();
        } else if( !isNull( cartId ) && !auth.check()){
        	//if user is not logged in check for active cart with null user
        	var activeCart = newEntity().where( 'id', cartId ).whereNull( 'FK_user').first();
        } else if( !isNull( cartId ) && auth.check() ) {
            var activeCart = newEntity().find( cartId );
        }

        if( isNull( activeCart ) ){
            activeCart = newEntity();
            if( auth.check() ){
                activeCart.customer().associate( auth.user() );
            }
            activeCart.save();
        }

        //persist the user if the cart was created before assigning
        if( auth.check() && isNull( activeCart.getCustomer() ) ){
        	// check if user has previous assigned cart
        	var userCart = newEntity().where( 'isActive', 1 ).where( 'FK_user', auth.user().getId() ).first();
        	if( !isNull( userCart ) ){
        		// merge products
        		for( var i in userCart.getContents().items ){
        			addItem( itemId=i.sku.id, quantity=i.quantity, targetCart=activeCart );
        		}
        		// deactivate old cart
        		userCart.setIsActive( 0 ).save();
        	}

        	activeCart.customer().associate( auth.user() );
            activeCart.save();
        }

        cookieStorage.set( "cartId", activeCart.getId() );

        return activeCart;


    }

}