component extends="coldbox.system.EventHandler"{
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest();
        return '<div id="app"></div>';
    }
    
}
