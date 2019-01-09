/**
* Payments Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" {

	property name="entityService" inject="PaymentService@cbCommerce";
	property name="userService" inject="UserService@cbCommerce";
	property name="orderService" inject="OrderService@cbCommerce";
	property name="processor" inject="StripeProcessor@cbCommerce";
	property name="cartService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/store/api/v1/payments'

	// (GET) /cbc/api/v1/payments
	function index( event, rc, prc ){

		var searchResults = entityService.search( rc, rc.maxrows, rc.offset, rc.sortOrder );

		prc.response.setData(
			fractal.builder()
				.collection( searchResults.collection )
				.withPagination( searchResults.pagination )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (POST) /cbc/api/v1/payments
	function create( event, rc, prc ){
		var isNewUser = false;
		if( !structKeyExists(prc, "authenticatedUser") ){
			// look for existing email
			prc.user = userService.retrieveUserByUsername(  rc.email  );

			if( isNull( prc.user ) ){
				var newUser = {};
				newUser.firstName = rc.billingAddress.firstName;
				newUser.lastName = rc.billingAddress.lastName;
				newUser.email = rc.email;
				newUser.primaryPhone = rc.phone;
				newUser.password = lcase( createGUID() );
				newUser.isActive = 0;

				prc.user = userService.newEntity().fill( newUser ).save();
				var isNewUser = true;

			}
		} else {
			prc.user = prc.authenticatedUser.getUser();
		}
		// create billing addresses
		if( isNull( rc.billingAddress.id ) || rc.billingAddress.id == ''){
			var newBillingAddress = {};

			newBillingAddress.address1 = rc.billingAddress.address1;
			newBillingAddress.address2 = rc.billingAddress.address2;
			newBillingAddress.city = rc.billingAddress.city;
			newBillingAddress.province = rc.billingAddress.province;
			newBillingAddress.postalCode = rc.billingAddress.postalCode;
			newBillingAddress.isPrimary = true;
			newBillingAddress.fullName = rc.billingAddress.firstName & " " & rc.billingAddress.LastName;
			newBillingAddress.designation = 'billing';

			prc.billingAddress =  prc.user.addresses().create( newBillingAddress );
		}

		// create shipping address
		if( isNull( rc.shippingAddress.id ) || rc.shippingAddress.id == '' ){
			var newShippingAddress = {};

			newShippingAddress.address1 = rc.shippingAddress.address1;
			newShippingAddress.address2 = rc.shippingAddress.address2;
			newShippingAddress.city = rc.shippingAddress.city;
			newShippingAddress.province = rc.shippingAddress.province;
			newShippingAddress.postalCode = rc.shippingAddress.postalCode;
			newShippingAddress.isPrimary = false;
			newShippingAddress.fullName = rc.shippingAddress.firstName & " " & rc.shippingAddress.LastName;
			newShippingAddress.designation = 'shipping';

			prc.shippingAddress =  prc.user.addresses().create( newShippingAddress );

		}

		// create order
		var newOrder = {};
		newOrder.subtotal = rc.subtotal;
		newOrder.shipping = rc.shippingCost;
		newOrder.tax = rc.tax;
		newOrder.fees = structKeyExists( rc, "fees" ) ? rc.fees : 0 ;
		newOrder.discount = structKeyExists( rc, "discount" ) ? rc.discount : 0 ;
		newOrder.total = newOrder.subtotal + newOrder.shipping + newOrder.tax + newOrder.fees - newOrder.discount;
		newOrder.FK_user = prc.user.getId();
		newOrder.FK_billingAddress = prc.billingAddress.getId();
		newOrder.FK_shippingAddress = prc.shippingAddress.getId();

		prc.order = orderService.newEntity().fill( newOrder ).save();

		// process payment
		var stripeResponse = processor.charge(
					amount = newOrder.total * 100,
					source = rc.source,
					description = prc.order.getId()
				);

		if( !structKeyExists( stripeResponse.getContent().content, "error") ){
			// add items to order
			var cartItems = cartService.getActiveCart().getContents().items;
			var cartId = cartService.getActiveCart().getId();

			for( var i in cartItems ) {
				var tempItem = {};
				writeDump( cartItems[ i ] );abort;
				tempItem.productSnapshot = SerializeJSON( cartItems[ i ].product );
				tempItem.quantatityOrdered = cartItems[ i ].quantity;
				tempItem.originalCost = cartItems[ i ].sku.cost;
				tempItem.originalPrice = cartItems[ i ].sku.MSRP;

				prc.order.items().create( tempItem );
			}

			cartService.getActiveCart().setOrder( prc.order );

			// create payment
			var tempPayment = {};
			tempPayment.externalTransactionId = stripeResponse.getContent().content.id;
			tempPayment.amount = stripeResponse.getContent().content.amount / 100;
			tempPayment.lastFour = stripeResponse.getContent().content.source.lastFour;
			tempPayment.paymentMethod = stripeResponse.getContent().content.source.brand;
			tempPayment.FK_order = prc.order.getId();

			prc.payment = entityService.newEntity().fill( tempPayment );

			validateModelOrFail( prc.payment );

			prc.payment.save();

			prc.response.setData(
				fractal.builder()
					.item( prc.payment )
					.withIncludes( rc.includes )
					.withTransformer( "PaymentTransformer@cbCommerce" )
					.withItemCallback(
						function( transformed ) {
							transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
							return transformed;
						}
					)
					.convert()
			).setStatusCode( STATUS.CREATED );
		} else{
			// delete all new entities
				// delete order
				// if new user delete user
			// send error
		}

	}

	// (GET) /cbc/api/v1/payments/:id
	function show( event, rc, prc ){

		prc.payment = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			fractal.builder()
				.item( prc.payment )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);
	}

	// (PUT|PATCH) /cbc/api/v1/payments/:id
	function update( event, rc, prc ) secured="Payments:Edit"{
		prc.payment = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.payment.fill( rc );

		validateModelOrFail( prc.payment );

		prc.payment.save();

		prc.response.setData(
			fractal.builder()
				.item( prc.payment )
				.withIncludes( rc.includes )
				.withTransformer( "PaymentTransformer@cbCommerce" )
				.withItemCallback(
					function( transformed ) {
						transformed[ "href" ] = this.APIBaseURL & '/' & transformed[ "id" ];
						return transformed;
					}
				)
				.convert()
		);

	}

	// (DELETE) /cbc/api/v1/payments/:id
	function delete( event, rc, prc ) secured="Payments:Manage"{

		prc.payment = entityService.newEntity().getOrFail( rc.id );
		prc.payment.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}