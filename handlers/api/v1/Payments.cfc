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
	property name="cartService" inject="CartService@cbCommerce";

	this.APIBaseURL = '/cbc/api/v1/payments';

	// (GET) /cbc/api/v1/payments
	function index( event, rc, prc ) secured="cbcOrder:Manage"{
		return super.index( argumentCollection=arguments );
	}

	// (POST) /cbc/api/v1/payments
	function create( event, rc, prc ){
		var isNewUser = !auth().check();
		var defaultShippingMethod = getInstance( "DeliveryMethod@cbCommerce" ).where( "isDefault", 1 ).first();
		param rc.processor = "Stripe";
		param rc.FK_deliveryMethod = defaultShippingMethod.getId();
		var processor = entityService.getProcessor( rc.processor );
		transaction{
			try{

				if( isNewUser ){
					// look for existing email
					prc.user = userService.retrieveUserByUsername(  rc.email  );

					if( isNull( prc.user ) ){
						var newUser = {};
						newUser.firstName = listFirst( rc.billingAddress.fullName, " " );
						newUser.lastName = listToArray( rc.billingAddress.fullName, " ").shift().toList( " " );
						newUser.email = rc.email;
						newUser.primaryPhone = rc.phone;
						newUser.password = lcase( createUUID() );
						newUser.isActive = 0;

						prc.user = userService.newEntity().fill( newUser ).save();
						var isNewUser = true;

					}
				} else {
					if( !len( prc.authenticatedUser.getPrimaryPhone() ) ){
						prc.authenticatedUser.setPrimaryPhone( rc.phone ).save();
					}
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
					newBillingAddress.fullName = rc.billingAddress.fullName;
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
					newShippingAddress.fullName = rc.shippingAddress.fullName;
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
				newOrder.FK_deliveryMethod = rc.FK_deliveryMethod;

				prc.order = orderService.newEntity().fill( newOrder ).save().refresh();

				// add items to order
				var cartItems = cartService.getActiveCart().getContents().items;
				var cartId = cartService.getActiveCart().getId();

				var orderItemEntity = getInstance( "OrderItem@cbCommerce" );
				for( var i in cartItems ) {
					var cartSKU = getInstance( "ProductSKU@cbCommerce" ).getOrFail( i.sku.id );
					var tempItem = {};
					tempItem.productSnapshot = SerializeJSON( i );
					tempItem.quantityOrdered = i.quantity;
					tempItem.originalPrice = cartSKU.getBasePrice() ?: cartSKU.getDisplayPrice();
					tempItem.originalCost = cartSKU.getCost() ?: 0;
					tempItem.FK_order = prc.order.getId();
					var orderItemEntity = orderItemEntity.newEntity().fill( tempItem );
					validateModelOrFail( orderItemEntity );
					orderItemEntity.save();
				}

				// process payment
				var processorResponse = processor.charge(
							amount = round( newOrder.total * 100 ),
							source = rc.source.id,
							description = prc.order.getId()
						);

				if( !structKeyExists( processorResponse.getContent().content, "error") ){

					cartService.getActiveCart()
						.setFK_order( prc.order.getId() )
						.setFK_user( prc.user.getId() )
						.setIsActive( 0 )
						.save();

					// create payment
					var tempPayment = {
						"isActive" : 1
					};

					tempPayment.externalTransactionId = processorResponse.getContent().content.id;
					tempPayment.amount = processorResponse.getContent().content.amount / 100;
					tempPayment.FK_order = prc.order.getId();
					switch( rc.processor ){
						case "Stripe":{
							tempPayment.lastFour = processorResponse.getContent().content.source.last4;
							tempPayment.paymentMethod = processorResponse.getContent().content.source.brand;
						}
					}

					prc.payment = entityService.newEntity().fill( tempPayment );

					validateModelOrFail( prc.payment );

					prc.payment.save();

					// set order approval time
					prc.order.setApprovalTime( prc.payment.getCreatedTime() ).save();

					// deactivate cart
					cookieStorage.delete( "cartId" );
					prc.response.setData(
						prc.payment.getMemento(
							includes=rc.includes,
							excludes=rc.excludes,
							defaults={ "href" : this.APIBaseURL },
							mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
						)
					).setStatusCode( STATUS.CREATED );

				} else{

					// delete order
					prc.order.delete();
					// set error response
					prc.response.setData(
						SerializeJSON( processorResponse.getContent().content.error )
					).setStatusCode( processorResponse.getContent().status );
				}

			} catch( any e ){
				transactionRollback();
				rethrow;
			}
		}

	}

	// (GET) /cbc/api/v1/payments/:id
	function show( event, rc, prc ) secured{

		prc.payment = entityService.newEntity().getOrFail( rc.id );
		if( !auth().user().hasPermission( "cbcOrder:Manage" ) && prc.payment.getOrder().getFK_User() != auth().user().getId() ){
			return onAuthorizationFailure( argumentCollection=arguments );
		}

		prc.response.setData(
			prc.payment.getMemento(
					includes=rc.includes,
					excludes=rc.excludes,
					defaults={ "href" : this.APIBaseURL },
					mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
				)
		);
	}

	// (PUT|PATCH) /cbc/api/v1/payments/:id
	function update( event, rc, prc ) secured="cbcOrder:Manage"{
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

				defaults={ "href" : this.APIBaseURL },
				mappers={ "href" : function( item, memento ){ return memento.href & "/" & memento.id; } }
			)
		);

	}

	// (DELETE) /cbc/api/v1/payments/:id
	function delete( event, rc, prc ) secured="cbcOrder:Manage"{

		prc.payment = entityService.newEntity().getOrFail( rc.id );
		prc.payment.delete();

		prc.response.setData({}).setStatusCode( STATUS.NO_CONTENT );

	}


}