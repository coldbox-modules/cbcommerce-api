<template>

    <div>
    	<generic-loader v-if="checkoutStatus == 'pending'" message="Processing Your Order. Please wait..."></generic-loader>
    	<div v-else>
	    	<div class="col-sm-9 block-form tabs-steps">
				<!-- Nav tabs -->
	            <ul class="nav nav-pills  nav-justified">
	                <li :class="{ 'active' : activeTab === 'shipping' }" id="shipping">
	                	<a
	                		href="#shipping"
	                		@click.prevent="activateTab('shipping')">

	                		<i class="fa fa-truck"></i>
	                		Shipping
	                	</a>
	                </li>

	                <li v-if="isValidated.shipping" :class="{ 'active' : activeTab === 'payment' }" id="payment">
	                	<a
	                		href="#payment"
	                		@click.prevent="activateTab('payment')"
	                		>

	                		<i class="fa fa-money"></i>
	                		Payment
	                	</a>
	                </li>
	                <li v-else>
	                	<a
	                		href="#"
	                		class="disabled">
	                		<i class="fa fa-money"></i>
	                		Payment
	                	</a>
	                </li>

	                <li v-if="isValidated.payment" :class="{ 'active' : activeTab === 'review' }" id="review">
	                	<a
	                		href="#review"
	                		@click.prevent="activateTab('review')">

		                	<i class="fa fa-check"></i>
		                	Order Review
	                	</a>
	                </li>
	                <li v-else>
	                	<a
	                		href="#"
	                		class="disabled">
	                		<i class="fa fa-check"></i>
	                		Order Review
	                	</a>
	                </li>
	            </ul>

	            <!-- Tab panes -->
	            <div class="tab-content">
	                <div class="tab-pane" :class="{ 'active' : activeTab === 'shipping' }" id="shipping">
	                    <br>
	                    <h3>Shipping Address</h3>
	                    <hr>
	                    <form role="form" method="post" action="#" data-vv-scope="form-shipping">
	                        <div class="row">
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label for="shippingFirstName" class="control-label">First Name:
	                                    	<span class="text-danger">*</span>
	                                    </label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingFirstName"
	                                        	name="shippingFirstName"
	                                        	v-validate="'required'"
	                                        	data-vv-as="First Name"
	                                        	v-model="selectedShippingAddress.firstName">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingFirstName')">

	                                        	{{ errors.first( 'form-shipping.shippingFirstName' ) }}
	                                        </span>
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="shippingLastName" class="control-label">Last Name:
	                                    	<span class="text-danger">*</span>
	                                    </label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingLastName"
	                                        	name="shippingLastName"
	                                        	v-validate="'required'"
	                                        	data-vv-as="Last Name"
	                                        	v-model="selectedShippingAddress.lastName">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingLastName')">

	                                        	{{ errors.first( 'form-shipping.shippingLastName' ) }}
	                                        </span>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label for="shippingAddress1" class="control-label">Address /1:
	                                    	<span class="text-danger">*</span>
	                                    </label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingAddress1"
	                                        	name="shippingAddress1"
	                                        	v-validate="'required'"
	                                        	data-vv-as="Address"
	                                        	v-model="selectedShippingAddress.address1">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingAddress1')">

	                                        	{{ errors.first( 'form-shipping.shippingAddress1' ) }}
	                                        </span>
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="shippingAddress2" class="control-label">Address /2:</label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingAddress2"
	                                        	v-model="selectedShippingAddress.address2">
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="shippingCity" class="control-label">City:
	                                    	<span class="text-danger">*</span>
	                                    </label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingCity"
	                                        	name="shippingCity"
	                                        	v-validate="'required'"
	                                        	data-vv-as="City"
	                                        	v-model="selectedShippingAddress.city">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingCity')">

	                                        	{{ errors.first( 'form-shipping.shippingCity' ) }}</span>
	                                    </div>
	                                </div>

	                                <div class="form-group">
	                                    <label for="shippingState" class="control-label">State/Province:
	                                    	<span class="text-danger">*</span>
	                                    </label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingState"
	                                        	name="shippingState"
	                                        	v-validate="'required'"
	                                        	data-vv-as="State"
	                                        	v-model="selectedShippingAddress.province">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingState')">

	                                        	{{ errors.first( 'form-shipping.shippingState' ) }}
	                                        </span>
	                                    </div>
	                                </div>

	                                <div class="form-group">
	                                    <label for="inputPostCode" class="control-label">Zip Code: <span class="text-danger">*</span></label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="shippingPostCode"
	                                        	name="shippingPostCode"
	                                        	v-validate="'required'"
	                                        	data-vv-as="Zip Code"
	                                        	v-model="selectedShippingAddress.postalCode">

	                                        <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-shipping.shippingPostCode')">

	                                        	{{ errors.first( 'form-shipping.shippingPostCode' ) }}
	                                        </span>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                    </form>
	                    <hr>
	                    <a href="/shopping-cart" class="btn-default-1">Back to Cart</a>
	                    <a href="#payment"
	                    	class="btn btn-default-1"
	                    	@click.prevent="validateShipping()">

	                    	Next
	                    </a>
	                </div>

	                <div class="tab-pane" :class="{ 'active': activeTab === 'payment' }" id="payment">
	                    <br>
	                    Pay with your credit card via Stripe

						<p v-if="!globalData.stripeKey" class="alert alert-danger">
							<strong>Warning</strong> : The Stripe integration for this site is not configured correctly.  Checkout will be unavailable until the correct configuration is provided.
						</p>
						
	                    <form role="form" method="post" action="#" data-vv-scope="form-payment">
		                    <div class="row">
		                    	<div class="col-md-6 ">
		                    		<div class="form-group">
		                                <label for="card-name" class="control-label">Name on Card:<span class="text-danger">*</span></label>
		                                <div>
		                                    <input
		                                    	type="text"
		                                    	class="form-control"
		                                    	id="nameOnCard"
		                                    	name="nameOnCard"
		                                        v-validate="'required'"
		                                        data-vv-as="Name on Card"
		                                    	v-model="selectedPayment.nameOnCard">

		                                    <span
	                                        	class="text-danger error-message"
	                                        	v-show="errors.has('form-payment.nameOnCard')">

	                                        	{{ errors.first( 'form-payment.nameOnCard' ) }}
	                                        </span>
		                                </div>
		                            </div>
		                    	</div>
		                    </div>
		                    <div class="row payment-fields">
		                    	<div class="col-md-6 ">
		                    		<div class="fieldset">
		                    			<label for="card-number" data-tid="elements_examples.form.card_label">Card:<span class="text-danger">*</span></label>
							            <div id="card-number" ref="cardNumber" class="field empty"></div>
							        </div>
		                        </div>
		                        <div class="col-md-4">
		                            <div class="form-group">
		                                <label for="card-expiry" class="control-label">Expiration Date:<span class="text-danger">*</span></label>
		                                <div id="card-expiry" ref="cardExpiry" class="field empty"></div>
		                            </div>
		                        </div>
		                        <div class="col-md-2">
		                            <div class="form-group">
		                                <label for="card-cvc" class="control-label">CCV:<span class="text-danger">*</span></label>
		                                <div id="card-cvc" ref="cardCvc" class="field empty"></div>
		                            </div>
		                        </div>
		                    </div>
		               		<div class="row">
		               			<div class="col-sm-12">
		               				<transition name="fade">
			               				<div class="error" role="alert" v-if="hasCardErrors">
								            <span class="message text-danger error-message">{{ cardErrorMessage }}</span>
								        </div>
								     </transition>
		               			</div>
		               		</div>
		               		<div class="row">
		                    	<br>
			                    <h3>Contact Info</h3>
			                    <div class="col-md-6">
				                    <div class="form-group">
		                                <label for="contactPhone" class="control-label">Phone:
		                                	<span class="text-danger">*</span>
		                                </label>
		                                <div>
		                                    <input
		                                    	type="text"
		                                    	class="form-control"
		                                    	id="contactPhone"
		                                    	name="contactPhone"
		                                    	v-validate="'required|numeric'"
		                                    	data-vv-as="Phone"
		                                    	v-model="phone">

		                                	<span
		                                    	class="text-danger error-message"
		                                    	v-show="errors.has('form-payment.contactPhone')">

		                                    	{{ errors.first( 'form-payment.contactPhone' ) }}
		                                    </span>
		                                </div>
		                            </div>
		                        </div>
		                        <div class="col-md-6">
				                    <div class="form-group">
		                                <label for="contactEmail" class="control-label">Email:
		                                	<span class="text-danger">*</span>
		                                </label>
		                                <div>
		                                    <input
		                                    	type="text"
		                                    	class="form-control"
		                                    	id="contactEmail"
		                                    	name="contactEmail"
		                                    	v-validate="'required|email'"
		                                    	data-vv-as="Email"
		                                    	v-model="email">

		                                	<span
		                                    	class="text-danger error-message"
		                                    	v-show="errors.has('form-payment.contactEmail')">

		                                    	{{ errors.first( 'form-payment.contactEmail' ) }}
		                                    </span>
		                                </div>
		                            </div>
		                        </div>
			                </div>
		                    <div class="row">
		                    	<br>
			                    <h3>Billing Address</h3>
		                    	<div class="checkbox">
								    <label>
								      <input type="checkbox"
										  v-model="sameAddress"
										  :true-value="true"
										  :false-value="false">

										  Same as Shipping Address
								    </label>
								</div>
			                    <hr>
			                    <div v-if="sameAddress">
			                    	<p>Same as shipping address.</p>
			                    </div>
			                    <div v-else>
				                    <div class="row">
			                            <div class="col-md-6">
			                                <div class="form-group">
			                                    <label for="billingFirstName" class="control-label">
			                                    	First Name:<span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingFirstName"
			                                        	name="billingFirstName"
			                                        	v-validate="'required'"
			                                        	data-vv-as="First Name"
			                                        	v-model="selectedBillingAddress.billingLastName"
			                                        	>

			                                        <span
			                                        	class="text-danger error-message"
			                                        	v-show="errors.has('form-payment.billingFirstName')">

			                                        	{{ errors.first( 'form-payment.billingFirstName' ) }}
			                                        </span>
			                                    </div>
			                                </div>
			                                <div class="form-group">
			                                    <label for="billingLastName" class="control-label">
			                                    	Last Name:
			                                    	<span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingLastName"
			                                        	name="billingLastName"
			                                        	v-validate="'required'"
			                                        	data-vv-as="Last Name"
			                                        	v-model="selectedBillingAddress.billingLastName">

			                                        	<span
				                                        	class="text-danger error-message"
				                                        	v-show="errors.has('form-payment.billingLastName')">

				                                        	{{ errors.first( 'form-payment.billingLastName' ) }}
				                                        </span>
			                                    </div>
			                                </div>
			                            </div>
			                            <div class="col-md-6">
			                                <div class="form-group">
			                                    <label for="billingAddress1" class="control-label">
			                                    	Address /1:
			                                    	<span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingAdress1"
			                                        	name="billingAdress1"
			                                        	v-validate="'required'"
			                                        	data-vv-as="Adress"
			                                        	v-model="selectedBillingAddress.billingAddress1">

			                                        <span
			                                        	class="text-danger error-message"
			                                        	v-show="errors.has('form-payment.billingAddress1')">

			                                        	{{ errors.first( 'form-payment.billingAddress1' ) }}
			                                        </span>
			                                    </div>
			                                </div>
			                                <div class="form-group">
			                                    <label for="billingAddress2" class="control-label">Address /2:</label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingAdress2"
			                                        	v-model="selectedBillingAddress.billingAddress2">
			                                    </div>
			                                </div>
			                                <div class="form-group">
			                                    <label for="billingCity" class="control-label">
			                                    	City: <span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingCity"
			                                        	name="billingCity"
			                                        	v-validate="'required'"
			                                        	data-vv-as="City"
			                                        	v-model="selectedBillingAddress.billingCity">

			                                        <span
			                                        	class="text-danger error-message"
			                                        	v-show="errors.has('form-payment.billingCity')">

			                                        	{{ errors.first( 'form-payment.billingCity' ) }}
			                                        </span>
			                                    </div>
			                                </div>

			                                 <div class="form-group">
			                                    <label for="billingState" class="control-label">
			                                    	State/Province:
			                                    	<span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingState"
			                                        	name="billingState"
			                                        	v-validate="'required'"
			                                        	data-vv-as="State"
			                                        	v-model="selectedBillingAddress.billingState">

			                                        <span
			                                        	class="text-danger error-message"
			                                        	v-show="errors.has('form-payment.billingState')">

			                                        	{{ errors.first( 'form-payment.billingState' ) }}
			                                        </span>
			                                    </div>
			                                </div>

			                                <div class="form-group">
			                                    <label for="billingPostCode" class="control-label">
			                                    	Zip Code:
			                                    	<span class="text-danger">*</span>
			                                    </label>
			                                    <div>
			                                        <input
			                                        	type="text"
			                                        	class="form-control"
			                                        	id="billingPostCode"
			                                        	name="billingPostCode"
			                                        	v-validate="'required'"
			                                        	data-vv-as="Zip Code"
			                                        	v-model="selectedBillingAddress.billingPostCode">

			                                        <span
			                                        	class="text-danger error-message"
			                                        	v-show="errors.has('form-payment.billingPostCode')">

			                                        	{{ errors.first( 'form-payment.billingPostCode' ) }}
			                                        </span>
			                                    </div>
			                                </div>
			                            </div>
			                        </div>
				                </div>
		                    </div>
	                	</form>
	                    <hr>
	                    <a
	                    	href="#shipping"
	                    	class="btn-default-1"
	                    	@click.prevent="activateTab('shipping')">

	                    	Back
	                    </a>
	                    <a
	                    	href="#review"
	                    	class="btn btn-default-1"
	                    	@click.prevent="validatePayment()">

	                    	Next
	                    </a>
	                </div>

	                <div class="tab-pane" :class="{ 'active': activeTab === 'review' }" id="review">
	                    <br>
	                    <h3>Review</h3>
	                    <br>
	                    <div
			    			v-for="(item, index) in cartProducts"
				            :key="index">

			    			<cart-item :item= "item" :show-actions="false">

							</cart-item>
						</div>

	                    <hr>
	                    <a href="#" class="btn-default-1" @click="purchase">Place Order</a>
	                </div>
	            </div>
	    	</div>

	    	<div class="col-sm-3">
		     	<div class="cart-buy-box">
					<div v-if="isValidated.payment && isValidated.shipping">
						<button
							class="btn btn-animate btn-fluid"
							@click="purchase"
						>

							Place Order
						</button><br/><br/>
						<!--- TODO: Use setting to get the app name -->
						<p>By Placing your order, you agree to App's name Privacy Notice.</p>
					</div>
			     	<div class="cart-summary">
			     		<h4>Order Summary</h4>
			     		<table class="table">
			     			<tbody>
			     				<tr>
			     					<th>Sub Total:</th>
			     					<td class="text-right">{{ subtotal | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Estimated Shipping:</th>
			     					<td class="text-right">{{ shippingCost | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Total Before Tax: </th>
			     					<td class="text-right">{{ subtotal + shippingCost | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Estimated Tax:</th>
			     					<td class="text-right">{{ tax | currency }}</td>
			     				</tr>
			     				<tr class="text-danger">
			     					<th>Order Total:</th>
			     					<td class="text-right">{{ subtotal + shippingCost + tax | currency }}</td>
			     				</tr>
			     			</tbody>
			     		</table>
			     	</div>

			    </div>
		     </div>
		</div>
    </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from "vuex";
import api from "@cbCommerce/api/index";
import imagesLoaded from 'vue-images-loaded';
import CartItem from './cart-item';

if( window.cbcGlobalData.stripeKey ){
	var stripe = Stripe( window.cbcGlobalData.stripeKey );
	var elements = stripe.elements();
}

var cardNumber = undefined;

export default {
	components: {
        CartItem
    },
    directives: {
        imagesLoaded
    },
    data() {
        return {
            isLoading: false,
            hasCardErrors : false,
            cardErrorMessage: "",
            activeTab: 'shipping',
            isValidated: {
            	shipping: false,
            	payment: false
            },
            selectedShippingAddress: {
            	id: "",
            	firstName: "",
            	lastName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: ""
            },
            selectedBillingAddress: {
            	id: "",
            	firstName: "",
            	lastName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: ""
            },
            sameAddress: false,
            selectedPayment: {
            	nameOnCard: ""
            },
            token: null,
            phone: "",
            email: ""
        }
    },
    computed: {
    	...mapState( {
    		globalData   : 'globalData'
    	}),
        ...mapGetters([
            "cartProducts",
			"checkoutStatus",
			"authUser"
        ]),
        subtotal: function(){
        	var subTotal = 0;
        	for( var i in this.cartProducts ){
        		let itemPrice = this.cartProducts[ i ].sku.basePrice;
        		let qty = this.cartProducts[ i ].quantity;

        		subTotal = subTotal + ( itemPrice * qty )
        	}
        	return subTotal;
        },
        shippingCost: function(){
        	return 0;
        },
        tax: function(){
        	return 0;
        }
    },

    created() {
        this.isLoading = true;
    },
     mounted() {
		// scope in our global data user
		if( this.authUser ){
			Vue.set( this.selectedShippingAddress, "firstName", this.authUser.firstName );
			Vue.set( this.selectedShippingAddress, "lastName", this.authUser.lastName );
			Vue.set( this.selectedBillingAddress, "firstName", this.authUser.firstName );
			Vue.set( this.selectedBillingAddress, "lastName", this.authUser.lastName );
			Vue.set( this, "email", this.authUser.email );
			Vue.set( this, "phone", this.authUser.primaryPhone );
		}
		this.isLoading = false;

        if( window.cbcGlobalData && window.cbcGlobalData.stripeKey ){
	        cardNumber = elements.create('cardNumber', { style: this.getBaseStyles(), classes: this.getElementClasses() });
			var cardExpiry = elements.create('cardExpiry', {  style: this.getBaseStyles()  });
			var cardCvc = elements.create('cardCvc', {  style: this.getBaseStyles() } );

	    	cardNumber.mount( this.$refs.cardNumber );
	    	cardExpiry.mount( this.$refs.cardExpiry );
	    	cardCvc.mount( this.$refs.cardCvc );

	    	this.registerElements( [ cardNumber, cardExpiry, cardCvc ] );
		}
    },
    methods: {

        ...mapActions([
            "setCheckoutStatus"
        ]),
        getStripe(){
        	return Stripe( this.globalData.stripeKey );
        },
        getElementClasses(){
        	var elementClasses = {
			    focus: 'focus',
			    empty: 'empty',
			    invalid: 'invalid',
			  };

			  return elementClasses;
        },
        getBaseStyles(){
        	var styles = {
        		base: {
			      color: '#555555',
			      fontSize: '14px',
			      fontSmoothing: 'antialiased',

			      ':focus': {
			        color: '#424770',
			      },

			      '::placeholder': {
			        color: '#9BACC8',
			      },

			      ':focus::placeholder': {
			        color: '#CFD7DF',
			      },
			    },
			    invalid: {
			      color: '#555555',
			      ':focus': {
			        color: '#FA755A',
			      },
			      '::placeholder': {
			        color: '#FFCCA5',
			      },
			    }
			};
        	return styles;
        },
        activateTab( tabRef ){
        	this.activeTab = tabRef;
        },
        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        },
        validateShipping(){
        	var self = this;
        	this.$validator.validate( 'form-shipping.*' ).then(( result ) => {
		        if ( result ) {
		          self.isValidated.shipping = true;
				  self.activateTab( 'payment' );
				  this.$scrollTo( $( '#payment' )[ 0 ] );
		        } else {
					self.isValidated.shipping = false;
					let $firstError = $( 'span.text-danger.error-message:visible' ).first();
					if( $firstError.length ){
						this.$scrollTo( $firstError[ 0 ], 500, { offset : -200 } );
					}
		        }
		    });
        },
        validatePayment(){
        	var self = this;

        	if( self.sameAddress ){
	    		self.selectedBillingAddress = Object.assign({}, self.selectedShippingAddress);
	    	}

	    	var billingData = self.selectedBillingAddress;

			// Gather additional customer data we may have collected in our form.
			var additionalData = {
	            name: self.selectedPayment.nameOnCard ? self.selectedPayment.nameOnCard : undefined,
	            address_line1: billingData.address1 ? billingData.address1 : undefined,
	            address_line2: billingData.address2 ? billingData.address1 : undefined,
	            address_city: billingData.city ? billingData.city : undefined,
	            address_state: billingData.province ? billingData.province : undefined,
	            address_zip: billingData.postalCode ? billingData.postalCode : undefined,
        	};

        	stripe.createToken( cardNumber, additionalData ).then( function( result ) {
		      	// Access the token with result.token
		      	if ( result.error ) {
	  				self.hasCardErrors = true;
	  				self.cardErrorMessage = result.error.message;
	  				self.isValidated.payment = false;
					let $firstError = $( 'span.text-danger.error-message:visible' ).first();
					if( $firstError.length ){
						self.$scrollTo( $firstError[ 0 ] );
					}
	  			} else {
	  				Vue.set( self, 'token', result.token );
	  				self.$validator.validate( 'form-payment.*' ).then(( result ) => {
				    	if ( result && self.token != null ) {
				          self.isValidated.payment = true;
						  self.activateTab( 'review' );
						  this.$scrollTo( $( '#review' )[ 0 ] );
				        } else {
							self.isValidated.payment = false;
							let $firstError = $( 'span.text-danger.error-message:visible' ).first();
							if( $firstError.length ){
								self.$scrollTo( $firstError[ 0 ] );
							}
				        }
				    });
	  			}
		    });
        },
		registerElements( elements ){
			let self = this;
			// Listen for errors from each Element, and show error messages in the UI.
		    elements.forEach( function ( element ) {
		        element.on( 'change', function ( event ) {
		            if ( event.error ) {
		            	self.hasCardErrors = true;
		                self.cardErrorMessage = event.error.message;
		            } else {
		            	self.hasCardErrors = false;
		            }
		        });

		        element.on( 'focus', function ( event ) {
		            self.hasCardErrors = false;
		            self.cardErrorMessage = '';
		        });

		    });
		},
		getToken(){
			let self = this;

			var billingData = self.selectedBillingAddress;

			// Gather additional customer data we may have collected in our form.
			var additionalData = {
	            name: self.selectedPayment.nameOnCard ? self.selectedPayment.nameOnCard : undefined,
	            address_line1: billingData.address1 ? billingData.address1 : undefined,
	            address_line2: billingData.address2 ? billingData.address1 : undefined,
	            address_city: billingData.city ? billingData.city : undefined,
	            address_state: billingData.province ? billingData.province : undefined,
	            address_zip: billingData.postalCode ? billingData.postalCode : undefined,
        	};

        	stripe.createToken( cardNumber, additionalData ).then( function( result ) {
		      	// Access the token with result.token
		      	if ( result.error ) {
	  				self.hasCardErrors = true;
	  				self.cardErrorMessage = result.error.message;
	  			} else {
	  				Vue.set( self, 'token', result.token );
	  			}
		    });

		},
		purchase(){
			let self = this;
			self.$store.commit('setCheckoutStatus', 'pending' );

			var payload = {};

	      	if ( self.token != null && self.isValidated.shipping && self.isValidated.payment ) {
  				// set payload
  				payload.phone = self.phone;
  				payload.email = self.email;
  				payload.shippingAddress = self.selectedShippingAddress;
  				payload.billingAddress = self.selectedBillingAddress;
  				payload.source = self.token.id;
  				payload.subtotal = self.subtotal;
  				payload.shippingCost = self.shippingCost;
  				payload.tax = self.tax;

  				api().post.checkout.process( payload )
					.then( XHR => {
						self.$store.commit('setCheckoutStatus', 'success' );
						window.location.replace( '/store/checkout/thankyou/' + XHR.data.id );
					})
					.catch( err => {
						console.error( err );
						reject( err );
					})
					.then( xhr => {
						self.$store.commit('setCheckoutStatus', 'error' );
					});
  			}
		}

    }
}
</script>