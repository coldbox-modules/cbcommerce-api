<template>
    <div>
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
                                        	class="text-danger"
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
                                        	class="text-danger"
                                        	v-show="errors.has('form-shipping.shippingLastName')">

                                        	{{ errors.first( 'form-shipping.shippingLastName' ) }}
                                        </span>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="shippingPhone" class="control-label">Phone:
                                    	<span class="text-danger">*</span>
                                    </label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="shippingPhone"
                                        	name="shippingPhone"
                                        	v-validate="'required|numeric'"
                                        	data-vv-as="Phone"
                                        	v-model="selectedShippingAddress.phone">

                                    	<span
                                        	class="text-danger"
                                        	v-show="errors.has('form-shipping.shippingPhone')">

                                        	{{ errors.first( 'form-shipping.shippingPhone' ) }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="shippingAdress1" class="control-label">Address /1:
                                    	<span class="text-danger">*</span>
                                    </label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="shippingAdress1"
                                        	name="shippingAdress1"
                                        	v-validate="'required'"
                                        	data-vv-as="Address"
                                        	v-model="selectedShippingAddress.address1">

                                        <span
                                        	class="text-danger"
                                        	v-show="errors.has('form-shipping.shippingAdress1')">

                                        	{{ errors.first( 'form-shipping.shippingAdress1' ) }}
                                        </span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="shippingAdress2" class="control-label">Address /2:</label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="shippingAdress2"
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
                                        	class="text-danger"
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
                                        	class="text-danger"
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
                                        	class="text-danger"
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
                    	@click.prevent="validateStep( 1 )">

                    	Next
                    </a>
                </div>

                <div class="tab-pane" :class="{ 'active': activeTab === 'payment' }" id="payment">
                    <br>
                    Pay with your credit card via Stripe
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
                                        	class="text-danger"
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
		               				 	<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 17 17">
							            	<path class="base" fill="#000" d="M8.5,17 C3.80557963,17 0,13.1944204 0,8.5 C0,3.80557963 3.80557963,0 8.5,0 C13.1944204,0 17,3.80557963 17,8.5 C17,13.1944204 13.1944204,17 8.5,17 Z"></path>
							              	<path class="glyph" fill="#FFF" d="M8.5,7.29791847 L6.12604076,4.92395924 C5.79409512,4.59201359 5.25590488,4.59201359 4.92395924,4.92395924 C4.59201359,5.25590488 4.59201359,5.79409512 4.92395924,6.12604076 L7.29791847,8.5 L4.92395924,10.8739592 C4.59201359,11.2059049 4.59201359,11.7440951 4.92395924,12.0760408 C5.25590488,12.4079864 5.79409512,12.4079864 6.12604076,12.0760408 L8.5,9.70208153 L10.8739592,12.0760408 C11.2059049,12.4079864 11.7440951,12.4079864 12.0760408,12.0760408 C12.4079864,11.7440951 12.4079864,11.2059049 12.0760408,10.8739592 L9.70208153,8.5 L12.0760408,6.12604076 C12.4079864,5.79409512 12.4079864,5.25590488 12.0760408,4.92395924 C11.7440951,4.59201359 11.2059049,4.59201359 10.8739592,4.92395924 L8.5,7.29791847 L8.5,7.29791847 Z"></path>
							            </svg>
							            <span class="message">{{ cardErrorMessage }}</span>
							        </div>
							     </transition>
	               			</div>
	               		</div>
	               	<!-- </form> -->
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
	                                        	class="text-danger"
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
		                                        	class="text-danger"
		                                        	v-show="errors.has('form-payment.billingLastName')">

		                                        	{{ errors.first( 'form-payment.billingLastName' ) }}
		                                        </span>
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="billingPhone" class="control-label">Phone:</label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="billingPhone"
	                                        	name="billingPhone"
	                                        	v-validate="'required'"
	                                        	data-vv-as="Phone"
	                                        	v-model="selectedBillingAddress.billingPhone">

	                                        <span
		                                        	class="text-danger"
		                                        	v-show="errors.has('form-payment.billingPhone')">

		                                        	{{ errors.first( 'form-payment.billingPhone' ) }}
		                                        </span>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label for="billingAdress1" class="control-label">
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
	                                        	v-model="selectedBillingAddress.billingAdress1">

	                                        <span
	                                        	class="text-danger"
	                                        	v-show="errors.has('form-payment.billingAdress1')">

	                                        	{{ errors.first( 'form-payment.billingAdress1' ) }}
	                                        </span>
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="billingAdress2" class="control-label">Address /2:</label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="billingAdress2"
	                                        	v-model="selectedBillingAddress.billingAdress2">
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
	                                        	class="text-danger"
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
	                                        	class="text-danger"
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
	                                        	class="text-danger"
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
                    	@click.prevent="validateStep(2)">

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
                    <a href="#" class="btn-default-1">Place Order</a>
                </div>
            </div>
    	</div>

    	<div class="col-sm-3">
	     	<div class="cart-buy-box">
	     		<button class="btn btn-animate btn-fluid" @click="purchase">Place Order</button><br/><br/>
	     		<p>By Placing your order, you agree to BSR's Privacy Notice.</p>

		     	<div class="cart-summary">
		     		<h4>Order Summary</h4>
		     		<table class="table">
		     			<tbody>
		     				<tr>
		     					<th>Sub Total:</th>
		     					<td class="text-right">${{ subtotal }}</td>
		     				</tr>
		     				<tr>
		     					<th>Estimated Shipping:</th>
		     					<td class="text-right">${{ shippingCost }}</td>
		     				</tr>
		     				<tr>
		     					<th>Total Before Tax: </th>
		     					<td class="text-right">${{ subtotal + shippingCost }}</td>
		     				</tr>
		     				<tr>
		     					<th>Estimated Tax:</th>
		     					<td class="text-right">${{ tax }}</td>
		     				</tr>
		     				<tr class="text-danger">
		     					<th>Order Total:</th>
		     					<td class="text-right">${{ subtotal + shippingCost + tax }}</td>
		     				</tr>
		     			</tbody>
		     		</table>
		     	</div>

		    </div>
	     </div>
    </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from "vuex";
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
            	firstName: "",
            	lastName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: "",
            	phone: ""
            },
            selectedBillingAddress: {
            	firstName: "",
            	lastName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: "",
            	phone: ""
            },
            sameAddress: false,
            selectedPayment: {
            	nameOnCard: ""
            }
        }
    },

    created() {
        this.isLoading = true;
    },
     mounted() {
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

    destroyed() {},

    computed: {
    	...mapState( {
    		globalData   : 'globalData'
    	}),
        ...mapGetters([
            "cartProducts"
        ]),
        subtotal(){
        	var subTotal = 0;
        	for( var i in this.cartProducts ){
        		let itemPrice = this.cartProducts[ i ].sku.basePrice;
        		let qty = this.cartProducts[ i ].quantity;

        		subTotal = subTotal + ( itemPrice * qty )
        	}
        	return subTotal;
        },
        shippingCost(){
        	return 0;
        },
        tax(){
        	return 0;
        }
    },

    methods: {

        ...mapActions([
            "setCurrentProduct",
            "clearCurrentProduct",
            "getListOfProducts",
            "addProductToCart",
            "addProductToWishlist",
            "addProductToComparisonList"
        ]),
        buildPaymentForm( stripe ){
        	console.log( elements );
        },
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
        validateAddress( address ){
        	var isValid = false;
        	for( var i in address ){
	    		if( address[ i ] == "" && i != "address2"){
		        	return false;
		        }
		        isValid = true;
	    	}
        	return isValid;
        },
        validateShipping(){
        	var self = this;
        	this.$validator.validate('form-shipping.*').then((result) => {
		        if (result) {
		          self.isValidated.shipping = true;
		          self.activateTab('payment');
		        } else {
		        	self.isValidated.shipping = false;
		        }
		    });
        },
        validatePayment(){
        	var self = this;
        	this.$validator.validate('form-payment.*').then((result) => {
		        if (result) {
		          self.isValidated.payment = true;
		          self.activateTab('review');
		        } else {
		        	self.isValidated.payment = false;
		        }
		    });
        },
        validateStep( step ){
			var proceed = false;

			switch( step ) {
			    case 1:
				    this.validateShipping();
			    	break;
			    case 2:
			    	if( this.sameAddress ){
			    		this.selectedBillingAddress = Object.assign({}, this.selectedShippingAddress);
			    	}
			    	this.validatePayment();
			    	break;
			    default:
			        proceed = false;
			}
			return proceed;
		},
		registerElements( elements ){
			let self = this;
			console.log( elements );
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
		purchase(){
			let self = this;

			if( self.sameAddress ){
				var billingData = self.selectedShippingAddress;
			} else {
				var billingData = self.selectedBillingAddress;
			}
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
	  				console.log( result.token );
	  			}
		    });
		}

    }
}
</script>