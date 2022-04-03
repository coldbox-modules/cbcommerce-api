component extends="coldbox.system.EventHandler"{
    function preHandler( event, rc, prc ){
        event.setDefaultLayout( "Store" );
    }

	function preEvent( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
		if( prc.isContentBoxContext ){
			prc.cbHelper.prepareUIRequest();
		}
	}
}