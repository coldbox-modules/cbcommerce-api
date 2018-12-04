/**
 *
 * @displayname Service Response Object
 * @package cbCommerce.models.response
 * @description Service Response object to ensure all service objects return consistently formatted responses
 * @author Jon Clausen <jclausen@ortussolutions.com>
 * @mapping cbCommerce.models.response.ServiceResponse
 * 
 **/
component accessors="true"{

	property name="result" 			type="any"			default="";
	property name="error" 			type="boolean"		default=0;
	property name="pagination"      type="struct";
	property name="messages" 		type="array";
	property name="responsetime"	type="numeric"		default=0;
	property name="cachedResponse" 	type="boolean"		default=0;

	/**
	* Constructor
	*/
	ServiceResponse function init(){
		//The container to hold our results ( e.g. - { "collection": [], "totalRecords":0 } )
		variables.result 			= {};
		//our error flag
		variables.error 			= false;
		//the pagination data
		variables.pagination		= {};
		//the array to hold our response messages ( e.g. - validation results )
		variables.messages 			= [];
		//A variable to maintain our response times for debugging and performance expectations
		variables.responsetime		= 0;
		//Our cache flag to signify whether our result was retrieved from the cache
		variables.cachedResponse 	= false;

		return this;
	}

	/**
	* Add some messages
	* @message Array or string of messages to incorporate
	*/
	function addMessage( required any message ){

		if( isSimpleValue( arguments.message ) ){ 
			arguments.message = [ arguments.message ]; 
		}
		
		variables.messages.addAll( arguments.message );
		
		return this;
	}

	/**
	* Returns a standard response formatted data packet
	*/
	function getResponse() {

		var packet = {
			"error" 		 = variables.error ? true : false,
			"messages" 		 = variables.messages,
			"result" 		 = variables.result
		};

		return packet;
	}
}