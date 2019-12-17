component extends="BaseHandler"{
    property name="cbHelper" inject="CBHelper@cb";

	function index( event, rc, prc ) cache="false"{
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "account/index" );
    }

	function login( event, rc, prc ) cache="false"{
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "account/login" );
    }

	function create( event, rc, prc ) cache="false"{
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "account/create" );
    }

    function edit( event, rc, prc ) cache="false" secured{
        // Tell ColdBox to use the ContentBox theme
       cbHelper.prepareUIRequest();
        event.setView( "account/edit" );
    }

    // /store/account/reset/:token
    function reset( event, rc, prc ) cache="false"{
        var user = getInstance( "User@cbCommerce" ).where( "resetToken", rc.token ).firstOrFail();
        auth().login( user );
        user.setResetToken( javacast( "null", 0 ) ).save();
        relocate( uri="/store/account/edit" );
    }

}