component extends="coldbox.system.EventHandler"{

	function index( event, rc, prc ){
        event.setLayout( "Main" );
    }
    
    function admin( event, rc, prc ){
        event.setLayout( "Admin" );
	}

}
