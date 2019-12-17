component extends="BaseHandler"{
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "product/index" );
    }

	function detail( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "product/detail" );
    }

    function comparison( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "product/comparison" );
    }

}
