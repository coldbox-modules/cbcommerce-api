/**
* Customer Carts Handler - API v1
* @package cbCommerce.handlers
* @author Esmeralda Acevedo <esme@ortussolutions.com>
*/

component extends="BaseAPIHandler"{

	property name="processor" inject="StripeProcessor@cbCommerce";

	// (POST) /store/api/v1/checkout/
	function process( event, rc, prc ){

		var response = processor.charge(
					amount = rc.amount,
					source = rc.source,
					description="test charge"
				);
		prc.response.setData(
			response
		);

	}
}