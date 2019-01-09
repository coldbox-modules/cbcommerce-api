component {
	property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
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
 }