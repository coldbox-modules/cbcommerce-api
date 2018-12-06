/**
 * A cool processor/Stripe entity
 */
component extends="BaseProcessor" implements="IPaymentProcessor" singleton{

	// DI
	property name="stripe" inject="stripe@stripecfml";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Retrieve a human readable name for the processor
	 */
	function getName(){
		return "Stripe CFML";
	}

	/**
	 * If there is a version attached to the processor then return it here.
	 */
	function getVersion(){
		return "1.x.x";
	}

	/**
	 * Get the payment processor SDK library implementation.  This will be getting the raw processor.
	 */
	any function getProcessor(){
		return variables.stripe;
	}

	/**
	 * Make a charge on the processor
	 *
	 * @amount The amount in cents to charge, example: $20 = 2000, $20.5 = 2050, it is required
	 * @source A payment source to be charged, usually this is a card token, a customer token, etc. It is required
	 * @currency Usually the three-letter ISO Currency code (Optional)
	 * @customerId A customer identifier to attach to the charge (Optional)
	 * @description The description of the charge (Optional)
	 * @headers A struct of headers to send with the processor (Optional)
	 * @metadata A struct of metadata to send to the processor (Optional)
	 */
	ProcessorResponse function charge(
		required numeric amount,
		required source,
		currency="usd",
		customerId,
		description="",
		struct metadata={}
	){
		var oResponse = newResponse();

		if( log.canDebug() ){
			log.debug( "Making a stripe call with the following data: #seralizeJSON( arguments )#" );
		}

		// Charge it baby!
		oResponse.setContent(
			variables.stripe.charges.create( argumentCollection=arguments )
		);

		// Check for errors
		if( oResponse.getContent().status >= 300 ){
			oResponse.setError( true );
		}

		if( log.canDebug() ){
			log.debug( "Stripe call response: #seralizeJSON( oResponse.getContent() )#" );
		}

		return oResponse;
	}

	/**
	 * Make a refund on the processor
	 *
	 * @charge The identifier of the charge to refund.
	 * @amount The amount in cents to refund, if not sent then the entire charge is refunded (Optional)
	 * @reason A reason of why the refund (Optional)
	 * @headers A struct of headers to send with the processor (Optional)
	 * @metadata A struct of metadata to send to the processor (Optional)
	 */
	ProcessorResponse function refund(
		required charge,
		numeric amount,
		reason="",
		struct metadata={}
	){
		var oResponse = newResponse();

		if( log.canDebug() ){
			log.debug( "Making a stripe call with the following data: #seralizeJSON( arguments )#" );
		}

		// Charge it baby!
		oResponse.setContent(
			variables.stripe.refunds.create( argumentCollection=arguments )
		);

		// Check for errors
		if( oResponse.getContent().status >= 300 ){
			oResponse.setError( true );
		}

		if( log.canDebug() ){
			log.debug( "Stripe call response: #seralizeJSON( oResponse.getContent() )#" );
		}

		return oResponse;
	}


}