component {
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "product/index" );
    }

	function detail( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "product/detail" );
    }

}
