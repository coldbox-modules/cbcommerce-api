component extends="BaseHandler"{
	property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ) cache="false"{
		// Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest();
        event.setView( "cart/index" );
	}
}