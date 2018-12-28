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

                <li v-if="validateStep( 1 )" :class="{ 'active' : activeTab === 'payment' }" id="payment">
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

                <li v-if="validateStep( 2 )" :class="{ 'active' : activeTab === 'review' }" id="review">
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
                    <form role="form" method="post" action="#">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="inputFirstName" class="control-label">First Name:<span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputFirstName"
                                        	v-model="selectedShippingAddress.firstName">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputLastName" class="control-label">Last Name:<span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputLastName"
                                        	v-model="selectedShippingAddress.lastName">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputPhone" class="control-label">Phone:<span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputPhone"
                                        	v-model="selectedShippingAddress.phone">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="inputAdress1" class="control-label">Address /1: <span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputAdress1"
                                        	v-model="selectedShippingAddress.address1">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputAdress2" class="control-label">Address /2:</label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputAdress2"
                                        	v-model="selectedShippingAddress.address2">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputCity" class="control-label">City: <span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputCity"
                                        	v-model="selectedShippingAddress.city">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputState" class="control-label">State/Province: <span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputState"
                                        	v-model="selectedShippingAddress.province">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputPostCode" class="control-label">Zip Code: <span class="text-danger">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputPostCode"
                                        	v-model="selectedShippingAddress.postalCode">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                    <hr>
                    <a href="/shopping-cart" class="btn-default-1">Back to Cart</a>
                    <a href="#payment"
                    	class="btn btn-default-1"
                    	:class="{ 'disabled' : !validateStep( 1 ) }"
                    	@click.prevent="activateTab('payment')">

                    	Next
                    </a>
                </div>

                <div class="tab-pane" :class="{ 'active': activeTab === 'payment' }" id="payment">
                    <br>
                    Pay with your credit card via Stripe
                    <div class="row">
                    	<div class="col-md-6 ">
                    		<div class="form-group">
                                <label for="card-name" class="control-label">Name on Card:<span class="text-danger">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="nameOnCard" v-model="selectedPayment.nameOnCard">
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
		                    <form role="form" method="post" action="#">
		                        <div class="row">
		                            <div class="col-md-6">
		                                <div class="form-group">
		                                    <label for="inputFirstName" class="control-label">First Name:<span class="text-danger">*</span></label>
		                                    <div>
		                                        <input
		                                        	type="text"
		                                        	class="form-control"
		                                        	id="inputFirstName"
		                                        	>
		                                    </div>
		                                </div>
		                                <div class="form-group">
		                                    <label for="inputLastName" class="control-label">Last Name:<span class="text-danger">*</span></label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputLastName">
		                                    </div>
		                                </div>
		                                <div class="form-group">
		                                    <label for="inputPhone" class="control-label">Phone:</label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputPhone">
		                                    </div>
		                                </div>
		                            </div>
		                            <div class="col-md-6">
		                                <div class="form-group">
		                                    <label for="inputAdress1" class="control-label">Address /1: <span class="text-danger">*</span></label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputAdress1">
		                                    </div>
		                                </div>

		                                <div class="form-group">
		                                    <label for="inputCity" class="control-label">City: <span class="text-danger">*</span></label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputCity">
		                                    </div>
		                                </div>

		                                 <div class="form-group">
		                                    <label for="inputState" class="control-label">State/Province: <span class="text-danger">*</span></label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputState">
		                                    </div>
		                                </div>

		                                <div class="form-group">
		                                    <label for="inputPostCode" class="control-label">Zip Code: <span class="text-danger">*</span></label>
		                                    <div>
		                                        <input type="text" class="form-control" id="inputPostCode">
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
		                    </form>
		                </div>
                    </div>
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
                    	:class="{ 'disabled' : !validateStep( 2 ) }"
                    	@click.prevent="activateTab('review')">

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

if( window.cbcGlobalData && window.cbcGlobalData.stripeKey ){
	const stripe = Stripe( window.cbcGlobalData.stripeKey );
	var elements = stripe.elements();
	var cardNumber = undefined;
}

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
            	nameOnCard: "",
            	card: "",
            	expireDate: "",
            	ccv: ""
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
        validatePayment(){
        	var isValid = false;
        	for( var i in this.selectedPayment ){
	    		if( this.selectedPayment[ i ] == ""){
		        	return false;
		        }
		        isValid = true;
	    	}
        	return isValid;
        },
        validateStep( step ){
			var proceed = false;

			switch( step ) {
			    case 1:
				    proceed = this.validateAddress( this.selectedShippingAddress );
			    	break;
			    case 2:
			    	if(
			    		( this.sameAddress || this.validateAddress( this.selectedBillingAddress ) )
			    		&& this.validatePayment()
			    	   ){
				        proceed = true;
			    	}
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
		                // $( errorMessage ).fadeIn()
		                // errorMessage.innerText = event.error.message;
		                self.cardErrorMessage = event.error.message;
		            } else {
		            	self.hasCardErrors = false;
		                // $( errorMessage ).fadeOut();
		            }
		        });

		        element.on( 'focus', function ( event ) {
		            self.cardErrorMessage = '';
		            // $( errorMessage ).fadeOut();
		        });

		    });
		},
		purchase(){
			let self = this;

			stripe.createToken( cardNumber ).then( function( result ) {
		      // Access the token with result.token
		      console.log(result);
		      	if ( result.error ) {
      				self.hasCardErrors = true;
      				self.cardErrorMessage = result.error.message;
      			}

		    });
		}

    }
}
</script>