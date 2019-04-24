component{
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "account/index" );
    }

	function login( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "account/login" );
    }

	function create( event, rc, prc ){
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "account/create" );
    }

    function edit( event, rc, prc ) secured{
        // Tell ColdBox to use the ContentBox theme
        cbHelper.prepareUIRequest( "modules" );
        event.setView( "account/edit" );
    }

    // /store/account/reset/:token
    function reset( event, rc, prc ){
        var user = getInstance( "User@cbCommerce" ).where( "resetToken", rc.token ).firstOrFail();
        auth().login( user );
        user.setResetToken( javacast( "null", 0 ) ).save();
        relocate( uri="/store/account/edit" );
    }

}