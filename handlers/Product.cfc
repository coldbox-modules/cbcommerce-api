component extends="BaseHandler"{

	function index( event, rc, prc ){
        event.setView( "product/index" );
    }

	function detail( event, rc, prc ){
        event.setView( "product/detail" );
    }

    function comparison( event, rc, prc ){
        event.setView( "product/comparison" );
    }

}
