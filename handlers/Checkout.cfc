component extends="BaseHandler"{
	property name="cartService" inject="CartService@cbCommerce";

	function index( event, rc, prc ){
		// Setup the Module  Entry Point
		prc.cbCommerceEntryPoint = getModuleConfig( "cbCommerce" ).entryPoint;
		// exit Handlers
		prc.xehShoppingCart = "#prc.cbCommerceEntryPoint#/shopping-cart";

		// // if cart is empty relocate to shopping cart
		if( !arrayLen( cartService.getActiveCart().getContents().items ) ){
			relocate( prc.xehShoppingCart );
		}

        prc.assetBag.addJavascriptToFooter("https://js.stripe.com/v3/");

        prc.globalData[ "stripeKey" ] = getModuleSettings( "stripecfml" ).publishableKey;
        event.setView( "checkout/index" );
    }

	function login( event, rc, prc ){
        event.setView( "checkout/login" );
    }

    function thankyou( event, rc, prc ){
        event.setView( "checkout/thankyou" );
    }
 }