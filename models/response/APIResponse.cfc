/**
 *
 * @displayname API Response
 * @package cbCommerce.models.responses
 * @description This is the API Response object cbCommerce API endpoints
 * @author Jon Clausen <jclausen@ortussolutions.com>
 *
 **/
component accessors="true"{

	property name="format" 			type="string" 		default="json";
	property name="data" 			type="any"			default="";
	property name="error" 			type="boolean"		default=0;
	property name="binary" 			type="boolean"		default=0;
	property name="messages" 		type="array";
	property name="location" 		type="string"		default="";
	property name="jsonCallback" 	type="string"		default="";
	property name="jsonQueryFormat" type="string"		default="query";
	property name="contentType" 	type="string"		default="";
	property name="statusCode" 		type="numeric"		default="200";
	property name="statusText" 		type="string"		default="OK";
	property name="responsetime"	type="numeric"		default="0";
	property name="cachedResponse" 	type="boolean"		default=0;
	property name="headers" 		type="array";
	property name="pagination"      type="struct";

	/**
	* Constructor
	*/
	APIResponse function init(){
		// Init properties
		variables.format 			= "json";
		variables.data 				= {};
		variables.error 			= false;
		variables.binary 			= false;
		variables.messages 			= [];
		variables.location 			= "";
		variables.jsonCallBack 		= "";
		variables.jsonQueryFormat 	= "query";
		variables.contentType 		= "";
		variables.statusCode 		= 200;
		variables.statusText 		=  "OK";
		variables.responsetime		= 0;
		variables.cachedResponse 	= false;
		variables.headers 			= [];
		variables.pagination        = {};

		return this;
	}

	/**
	* Add some messages
	* @message Array or string of message to incorporate
	*/
	function addMessage( required any message ){
		if( isSimpleValue( arguments.message ) ){ arguments.message = [ arguments.message ]; }
		variables.messages.addAll( arguments.message );
		return this;
	}

	/**
	* Add a header
	* @name The header name ( e.g. "Content-Type" )
	* @value The header value ( e.g. "application/json" )
	*/
	function addHeader( required string name, required string value ){
		arrayAppend( variables.headers, { name=arguments.name, value=arguments.value } );
		return this;
	}

	/**
	* Returns a standard response formatted data packet
	* @reset Reset the 'data' element of the original data packet
	*/
	function getDataPacket( boolean reset=false ) {
		var packet = {
			"error" 		 = variables.error ? true : false,
			"messages" 		 = variables.messages,
			"data" 			 = variables.data
		};

		if( !structIsEmpty( variables.pagination ) ){
			packet.data[ "pagination" ] = variables.pagination;
		}

		// Are we reseting the data packet
		if( arguments.reset ){
			packet.data = {};
		}

		return packet;
	}
}