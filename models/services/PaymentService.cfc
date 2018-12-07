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

	function onDIComplete(){
		variables.processor = wirebox.getInstance( settings.payments.processor.default );
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
	cbcommerce.models.processor.IPaymentProcessor function getProcessor(){
		return variables.processor;
	}

	/**
	 * provider Payment entities - this provider must exist to use the search() method
	 */
    function newEntity() provider="Payment@cbCommerce"{}

}