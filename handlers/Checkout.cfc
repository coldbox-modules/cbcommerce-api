component {
	property name="cbHelper" inject="CBHelper@cb";
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

        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );

        prc.assetBag.addJavascriptToFooter("https://js.stripe.com/v3/");

        prc.globalData[ "stripeKey" ] = getModuleSettings( "stripecfml" ).publishableKey;
        event.setView( "checkout/index" );
    }

	function login( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "checkout/login" );
    }

    function thankyou( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "checkout/thankyou" );
    }
 }