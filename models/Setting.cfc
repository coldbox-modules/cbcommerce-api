/**
* cboxCommerce Setting Entity
*/
component   table="cbc_settings"
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
   property name="name" type="string";
   property name="value" type="string";

   property name="exposedSettings" persistent="false";

   function init(){
		variables.exposedSettings = [
			"features",
			"deliveryMethods"
		];
		return super.init();
   }


   function setValue( required value ){
	  variables.value = isSimpleValue( arguments.value ) ? arguments.value : serializeJSON( arguments.value, false, listFindNoCase( "Lucee", server.coldfusion.productname ) ? "utf-8" : false );
   }

   function getValue(){
	   return isValid( "JSON", variables.value ) ? deserializeJSON( variables.value ) : variables.value;
   }

   function filterSearch(
		required struct searchCollection,
		required QueryBuilder builder
	){

		if( structKeyExists( searchCollection, "exposedOnly" ) && searchCollection.exposedOnly ){
			this.scopeWhereNameIn( builder, variables.exposedSettings );
		}

	}

	function scopeWhereName( query, array condition ){
		return query.whereIn( "name", condition );
	}



}