component {
    property name="cbHelper" inject="CBHelper@cb";

    // ( GET ) /store/category
	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "category/index" );
    }

    // ( GET ) /store/category/:id
	function detail( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "category/detail" );
    }

    // ( GET ) /store/category/used
	function used( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "category/used" );
    }

}
