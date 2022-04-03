/**
 *
 * @displayname Global Data Interceptor
 * @package cbCommerce.interceptors
 * @description This interceptor marshalls data needed for picklists, etc.
 * @author Esmeralda Acevedo <esme@ortussolutions.com>
 *
 **/
 component{
    property name="templateCache" inject="cachebox:template";
    property name="mediaConfig" inject="coldbox:setting:media@cbCommerce";
    property name="resultsMapper" inject="ResultsMapper@mementifier";

 	void function preProcess( event, interceptData, buffer, rc, prc ) {
		prc.isContentBoxContext = getController().getModuleService().isModuleRegistered( "contentbox" );
		if( prc.isContentBoxContext ){
			prc.cbHelper = getInstance( "CBHelper@cb" );
		}
        // set globalData if not present in prc.
        if( !structKeyExists( prc, "globalData" ) ){
            prc[ "globalData" ] = {
                "placeholderImage" : mediaConfig.placeholderImage,
                "fwLocale" : getFWLocale()
            };
        }

        // set assetBag if not present in prc
        if( !structKeyExists( prc, "assetBag" ) ){
            prc[ "assetBag" ] = wirebox.getInstance( "AssetBag@coldbox-asset-bag" );
        }

        prc.globalData[ "@token" ] = CSRFGenerateToken( "cbCommerce" );

        prc.globalData[ "productConditions" ] = templateCache.getOrSet(
            "cbCommerce_global_productConditions",
            function(){
                var model = wirebox.getInstance( "ProductCondition@cbCommerce" );
                var builder = model.newQuery().where( "isActive", 1 );
                var conditions = model.get();

				return variables.resultsMapper.process(
					collection=conditions,
					includes="parent"
				);
            }
        );


        // Scope in i18n Resource bundles and format for Vue plugin
        prc.globalData[ "i18n" ] = templateCache.getOrSet(
            "cbCommerce_global_i18n",
            function(){
                var resourceService = getInstance( "ResourceService@cbi18n");
                var bundles = resourceService.getBundles();
                var commerceBundles = structKeyArray( bundles )
                                        .filter( function( key ){
                                            return left( key, 10 ) == 'cbcommerce';
                                        } );
                var i18nGlobals = {};
                commerceBundles.each( function( bundleName ){
                    var resource = bundles[ bundleName ];
                    //loop our languages and create the struct
                    structKeyArray( resource ).each( function( lang ){
                        if( !structKeyExists( i18nGlobals, lang ) ){
                            i18nGlobals[ lang ] = {};
                        }
                        if( len( bundleName ) > 10 ){
                            i18nGlobals[ lang ][ right( bundleName, len( bundleName )-10 ) ] = resource[ lang ];
                        } else {
                            i18nGlobals[ lang ] = resource[ lang ];
                        }
                    } );
                } );

                return i18nGlobals;
            }
        );

        // if logged in, add the authUser to globalData
        if( auth().isLoggedIn() ){
            prc.globalData[ "cbcAuthUser" ] = auth().getUser().getMemento();
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