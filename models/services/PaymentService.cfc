/**
 * Manage payments in CBCommerce via chosen processors
 */
component extends="BaseQuickEntityService" singleton threadsafe{

	// DI
	property name="settings" 	inject="coldbox:moduleSettings:cbCommerce";
	property name="wirebox"		inject="wirebox";
	property name="log" 		inject="logbox:logger:{this}";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}
	/**
	 * Get the current processor name
	 */
	function getProcessorName(){
		return getProcessor().getName();
	}

	/**
	 * Get the current system processor implementation
	 */
	cbcommerce.models.processor.IPaymentProcessor function getProcessor( required name ){
		return wirebox.getInstance( arguments.name & "Processor@cbCommerce" );
	}

	/**
	 * provider Payment entities - this provider must exist to use the search() method
	 */
    function newEntity() provider="Payment@cbCommerce"{}

}