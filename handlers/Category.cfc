component extends="BaseHandler"{

    // ( GET ) /store/category
	function index( event, rc, prc ) cache="false"{
        event.setView( "category/index" );
    }

    // ( GET ) /store/category/:id
	function detail( event, rc, prc ){
        event.setView( "category/detail" );
    }

    // ( GET ) /store/category/used
	function used( event, rc, prc ){
        event.setView( "category/used" );
    }

}
