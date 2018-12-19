component {
	property name="cbHelper" inject="CBHelper@cb";

	function login( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "checkout/login" );
    }
 }