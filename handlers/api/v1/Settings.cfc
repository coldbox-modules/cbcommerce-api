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
		prc.settings = variables.settings.reduce( function( acc, key, value ){
			if( isAdmin ){
				acc[ key ] = value;
			}
			// payment configuration is always sent
			else if( key == "payments" ){
				acc[ key ] = {
					"processors" : value.processors.reduce(
										function( acc, proc ){
											var entry = {
												"name" : proc.name
											};
											if( proc.keyExists( "expose" ) ){
												entry.append( proc.expose, true );
											}
											acc.append( entry );
											return acc;
										},
										[]
									)
				}
			}
			else if( exposedSettings.contains( key ) ){
				acc[ key ] = value;
			}
			return acc;
		}, {} );

		prc.settings[ "deliveryMethods" ] = getInstance( "DeliveryMethod@cbCommerce" )
												.where( "isActive", "=", 1 )
												.orderBy( "sortOrder" )
												.get()
												.map( function( dm ){ return dm.getMemento(); } );

		prc.response.setData( prc.settings ).setStatusCode( status.SUCCESS );
	}
}