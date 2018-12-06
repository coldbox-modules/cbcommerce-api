/**
 * This is the interface that every processor must implement in order to work with cbCommerce
 */
interface{

	/**
	 * Retrieve a human readable name for the processor
	 */
	function getName();

	/**
	 * If there is a version attached to the processor then return it here.
	 */
	function getVersion();

	/**
	 * Get the payment processor SDK library implementation.  This will be getting the raw processor.
	 */
	any function getProcessor();

	/**
	 * Make a charge on the processor.  Please note that any EXTRA arguments added to a processor
	 * The processor implementation must take care of them.
	 *
	 * @amount The amount in cents to charge, example: $20 = 2000, $20.5 = 2050, it is required
	 * @source A payment source to be charged, usually this is a card token, a customer token, etc. It is required
	 * @currency Usually the three-letter ISO Currency code (Optional)
	 * @customerId A customer identifier to attach to the charge (Optional)
	 * @description The description of the charge (Optional)
	 * @metadata A struct of metadata to send to the processor (Optional)
	 */
	ProcessorResponse function charge(
		required numeric amount,
		required source,
		currency,
		customerId,
		description,
		struct metadata={}
	);

	/**
	 * Make a refund on the processor.  Please note that any EXTRA arguments added to a processor
	 * The processor implementation must take care of them.
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
		reason,
		struct metadata={}
	);

}