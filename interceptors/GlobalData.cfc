/**
 *
 * @displayname Global Data Interceptor
 * @package cbCommerce.interceptors
 * @description This interceptor marshalls data needed for picklists, etc.
 * @author Esmeralda Acevedo <esme@ortussolutions.com>
 *
 **/
 component{
 	void function preProcess( event, interceptData, buffer, rc, prc ) {

        if( !structKeyExists( prc, "globalData" ) ){
            prc[ "globalData" ] = {};
        }

        // if logged in, add the authUser to globalData
        if( !isNull( prc.authCBCUser ) ){

            prc.globalData[ "cbcAuthUser" ] = prc.authCBCUser.getMemento();

        }
    }

    function cbui_beforeBodyEnd( event, interceptData, buffer, rc, prc ){
    	var globalDataScript = "<script>window.cbcGlobalData = " & serializeJSON( prc.globalData ) & ";</script>";

        arguments.buffer.append( globalDataScript );
    }
}