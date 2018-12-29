component extends="coldbox.system.EventHandler"{
    property name="cbHelper" inject="CBHelper@cb";

    function index( event, rc, prc ){
        event.setView( "admin/frame" );
    }
    
    function app( event, rc, prc ){
        event.setLayout( "Admin" );
    }

}
