/**
 * This response object is a standardized response for all payment processor gateways
 */
component accessors="true"{

	/**
	 * The error flag if there was an exception in the call
	 */
	property name="error" 			type="boolean"		default="false";

	/**
	 * The raw content returned from the gateway, this can be any format
	 */
	property name="content" 		type="any"			default="";

	/**
	 * Constructor
	 */
	function init(){
		// Init properties
		variables.content 	= "";
		variables.error 	= false;

		return this;
	}

	this.memento.defaultIncludes = [
		"content",
		"error"
	];

}