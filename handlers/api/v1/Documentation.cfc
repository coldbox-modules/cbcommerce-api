/**
* cbCommerce API Documentation Handler - API v1
* @package cbCommerce.handlers.api.v1
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="moduleSettings" inject="coldbox:moduleSettings:cbcommerce";
	property name="docsParser";
	function onDIComplete(){
		variables.docsParser = new cbswagger.models.RoutesParser();
		getWirebox().autowire( target=variables.docsParser, targetId="cbcommerce.api.routesParser" );
		var apiSettings = duplicate( variables.moduleSettings.cbswagger );
		apiSettings.routes = [ "cbc/api/v1" ];
		apiSettings.excludeRoutesPrefix = [];
		apiSettings.excludeRoutes = [];
		docsParser.setModuleSettings( apiSettings );
		docsParser.setHandlersPath( "/cbcommerce/handlers/api/v1" );
		docsParser.setHandlersInvocationPath( "cbcommerce.handlers.api.v1" );
	}

	function index( event, rc, prc ){
		prc.apiDocument= docsParser.createDocFromRoutes();
		prc.response.setData( prc.apiDocument.getNormalizedDocument() );
	}
}