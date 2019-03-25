component{
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "wishlist/index" );
    }

    function edit( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "wishlist/edit" );
    }

	function detail( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "wishlist/detail" );
    }
}