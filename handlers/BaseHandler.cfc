component extends="coldbox.system.EventHandler"{
    function preHandler( event, rc, prc ){
        event.setDefaultLayout( "Store" );
    }
}