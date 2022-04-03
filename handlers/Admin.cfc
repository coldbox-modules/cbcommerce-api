component extends="coldbox.system.EventHandler"{

    function index( event, rc, prc ){
        event.setView( "admin/frame" );
    }

    function app( event, rc, prc ){
        event.setLayout( "Admin" );
    }

}
