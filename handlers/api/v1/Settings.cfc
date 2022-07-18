/**
* Products Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler"{
	property name="entityService" inject="SettingService@cbCommerce";
	property name="settings" 	inject="coldbox:moduleSettings:cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/settings';

	// (GET) /cbc/api/v1/product-categories
	function index( event, rc, prc ){
		var exposedSettings = entityService.newEntity().getExposedSettings();
		var isAdmin = auth().check() && auth().getUser().isInRole( "Administrator" );
		prc.response.setData(
			variables.settings.reduce( function( acc, key, value ){
				if( isAdmin ){
					acc[ key ] = value;
				}
				else if( exposedSettings.contains( key ) ){
					acc[ key ] = value;
				}
				return acc;
			}, {} )
		).setStatusCode( status.SUCCESS );
	}
}