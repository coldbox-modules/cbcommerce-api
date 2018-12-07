/**
 * A Base processor utility
 */
component accessors="true"{

	// Global DI
	property name="wirebox" inject="wirebox";
	property name="log" 	inject="logbox:logger:{this}";

	/**
	 * Get a new reponse object
	 */
	function newResponse() provider="ProcessorResponse@cbCommerce";

}

