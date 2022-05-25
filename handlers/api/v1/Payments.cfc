/**
* Payments Handler - API v1
* @package cbCommerce.handlers
* @author Jon Clausen <jclausen@ortussolutions.com>
*/
component extends="BaseAPIHandler" {

	property name="cookieStorage" inject="CookieStorage@cbCommerce";
	property name="entityService" inject="PaymentService@cbCommerce";
	property name="userService" inject="UserService@cbCommerce";
	property name="orderService" inject="OrderService@cbCommerce";
	property name="processor" inject="StripeProcessor@cbCommerce";
	property name="cartService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/payments';

	// (GET) /cbc/api/v1/payments
	function index( event, rc, prc ){
		return super.index( argumentCollection=arguments );
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
				newUser.password = lcase( createUUID() );
				newUser.isActive = 0;

				prc.user = userService.newEntity().fill( newUser ).save();
				var isNewUser = true;

			}
		} else {
			prc.user = prc.authenticatedUser;
		}
		// create billing addresses
		if( isNull( rc.billingAddress.id ) || rc.billingAddress.id == ''){
			var newBillingAddress = {};

			newBillingAddress.address1 = rc.billingAddress.address1;
			newBillingAddress.address2 = rc.billingAddress.address2;
			newBillingAddress.city = rc.billingAddress.city;
			newBillingAddress.province = left( rc.billingAddress.province, 3 );
			newBillingAddress.postalCode = rc.billingAddress.postalCode;
			newBillingAddress.isPrimary = true;
			newBillingAddress.fullName = rc.billingAddress.firstName & " " & rc.billingAddress.LastName;
			newBillingAddress.designation = 'billing';

			prc.billingAddress =  prc.user.addresses().create( newBillingAddress );
		} else {
			prc.billingAddress =  prc.user.addresses().find( rc.billingAddress.id );
		}

		// create shipping address
		if( isNull( rc.shippingAddress.id ) || rc.shippingAddress.id == '' ){
			var newShippingAddress = {};

			newShippingAddress.address1 = rc.shippingAddress.address1;
			newShippingAddress.address2 = rc.shippingAddress.address2;
			newShippingAddress.city = rc.shippingAddress.city;
			newShippingAddress.province = left( rc.shippingAddress.province, 3 );
			newShippingAddress.postalCode = rc.shippingAddress.postalCode;
			newShippingAddress.isPrimary = false;
			newShippingAddress.fullName = rc.shippingAddress.firstName & " " & rc.shippingAddress.LastName;
			newShippingAddress.designation = 'shipping';

			prc.shippingAddress =  prc.user.addresses().create( newShippingAddress );

		} else {
			prc.shippingAddress =  prc.user.addresses().find( rc.shippingAddress.id );
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

		// add items to order
		var cartItems = cartService.getActiveCart().getContents().items;
		var cartId = cartService.getActiveCart().getId();

		for( var i in cartItems ) {
			var tempItem = {};
			tempItem.productSnapshot = SerializeJSON( i );
			tempItem.quantatityOrdered = i.quantity;
			tempItem.originalCost = i.sku.cost;
			tempItem.originalPrice = i.sku.basePrice;

			prc.order.items().create( tempItem );
		}

		// process payment
		var stripeResponse = processor.charge(
					amount = round( newOrder.total * 100 ),
					source = rc.source,
					description = prc.order.getId()
				);

		if( !structKeyExists( stripeResponse.getContent().content, "error") ){

			cartService.getActiveCart().setFK_order( prc.order.getId() ).save();
			cartService.getActiveCart().setFK_user( prc.user.getId() ).save();

			// create payment
			var tempPayment = {
				"isActive" : 1
			};
			tempPayment.externalTransactionId = stripeResponse.getContent().content.id;
			tempPayment.amount = stripeResponse.getContent().content.amount / 100;
			tempPayment.lastFour = stripeResponse.getContent().content.source.last4;
			tempPayment.paymentMethod = stripeResponse.getContent().content.source.brand;
			tempPayment.FK_order = prc.order.getId();

			prc.payment = entityService.newEntity().fill( tempPayment );

			validateModelOrFail( prc.payment );

			prc.payment.save();

			// set order approval time
			prc.order.setApprovalTime( prc.payment.getCreatedTime() ).save();
			// deactivate cart
			cartService.getActiveCart().setIsActive( 0 ).save();
			cookieStorage.deleteVar( "cartId" );
			prc.response.setData(
				prc.payment.getMemento(
					includes=rc.includes,
					excludes=rc.excludes,
					defaults={ "href" : variables.hrefDefault },
					mappers={ "href" : variables.hrefMapper }
				)
			).setStatusCode( STATUS.CREATED );
		} else{

			// delete order
			prc.order.delete();
			// delete user if new
			if( isNewUser ){
				prc.billingAddress.delete();
				prc.shippingAddress.delete();
				prc.user.delete();
			}
			// set error response
			prc.response.setData(
				SerializeJSON( stripeResponse.getContent().content.error )
			).setStatusCode( stripeResponse.getContent().status );
		}

	}

	// (GET) /cbc/api/v1/payments/:id
	function show( event, rc, prc ){

		prc.payment = entityService.newEntity().getOrFail( rc.id );

		prc.response.setData(
			prc.payment.getMemento(
					includes=rc.includes,
					excludes=rc.excludes,
					defaults={ "href" : variables.hrefDefault },
					mappers={ "href" : variables.hrefMapper }
				)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/payments/:id
	function update( event, rc, prc ) secured="cbcPayments:Edit"{
		prc.payment = entityService.newEntity().getOrFail( rc.id );
		//remove this key before population
		structDelete( rc, "id" );

		prc.payment.fill( rc );

		validateModelOrFail( prc.payment );

		prc.payment.save();

		prc.response.setData(
			prc.payment.getMemento(
				includes=rc.includes,
				excludes=rc.excludes,
				defaults={ "href" : variables.hrefDefault },
				mappers={ "href" : variables.hrefMapper }
			)
		);

	}

	// (DELETE) /cbc/api/v1/payments/:id
	function delete( event, rc, prc ) secured="cbcPayments:Manage"{

		prc.payment = entityService.newEntity().getOrFail( rc.id );
		prc.payment.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}