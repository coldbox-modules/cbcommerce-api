/**
 *
 * @displayname Global Data Interceptor
 * @package cbCommerce.interceptors
 * @description This interceptor marshalls data needed for picklists, etc.
 * @author Esmeralda Acevedo <esme@ortussolutions.com>
 *
 **/
 component{
    property name="auth" inject="authenticationService@cbauth";

 	void function preProcess( event, interceptData, buffer, rc, prc ) {
        // set globalData if not present in prc.
        if( !structKeyExists( prc, "globalData" ) ){
            prc[ "globalData" ] = {};
        }

        // set assetBag if not present in prc
        if( !structKeyExists( prc, "assetBag" ) ){
            prc[ "assetBag" ] = wirebox.getInstance( "AssetBag@coldbox-asset-bag" );
        }

        // if logged in, add the authUser to globalData
        if( auth.isLoggedIn() ){
            prc.globalData[ "cbcAuthUser" ] = getInstance( "Manager@cffractal" )
                .builder()
				.item( auth.getUser() )
				.withTransformer( "UserTransformer@cbCommerce" )
				.convert();
        }
    }

    function cbui_beforeBodyEnd( event, interceptData, buffer, rc, prc ){
    	var globalDataScript = "window.cbcGlobalData = " & serializeJSON( prc.globalData ) & ";";
    	prc.assetBag.addInlineJavascriptToFooter(
		    globalDataScript
		).setPriority(1);

        arguments.buffer.append( prc.assetBag.renderFooter() );
    }
}