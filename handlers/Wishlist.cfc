component extends="BaseHandler"{

	function index( event, rc, prc ){
        event.setView( "wishlist/index" );
    }

    function edit( event, rc, prc ){
        event.setView( "wishlist/edit" );
    }

	function detail( event, rc, prc ){
        event.setView( "wishlist/detail" );
    }
}