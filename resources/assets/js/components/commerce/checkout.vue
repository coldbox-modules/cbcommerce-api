<template>
    <div>
    	<div class="col-sm-9 block-form">
			<!-- Nav tabs -->
            <ul class="nav nav-pills  nav-justified">
                <li>
                	<a
                		href="#shipping"
                		@click.prevent="activateTab('shipping')">

                		<i class="fa fa-truck"></i>
                		Shipping
                	</a>
                </li>
                <li v-if="validateStep( 1 )">
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
                <li>
                	<a
                		href="#review"
                		@click.prevent="activateTab('review')">

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
                    	<div class="col-md-6">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Name on Card:<span class="text-danger">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="nameOnCard">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Card:<span class="text-danger">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="card">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Expiration Date:<span class="text-danger">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="expireDate">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">CCV:<span class="text-danger">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="ccv">
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
                    	@click.prevent="activateTab('payment')">

                    	Back
                    </a>
                    <a
                    	href="#review"
                    	type="button"
                    	class="btn-default-1"
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

		    			<cart-item :item= "item">

						</cart-item>
					</div>

                    <hr>
                    <a href="#" class="btn-default-1">Pay</a>
                </div>
            </div>
    	</div>

    	<div class="col-sm-3">
	     	<div class="cart-buy-box">
	     		<button class="btn btn-animate">Place Order</button><br/>
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
		     					<th>Shipping &amp; Handling:</th>
		     					<td class="text-right">${{ shippingCost }}</td>
		     				</tr>
		     				<tr>
		     					<th>Total Before Tax: </th>
		     					<td class="text-right">${{ subtotal + shippingCost }}</td>
		     				</tr>
		     				<tr>
		     					<th>Tax:</th>
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
            	name: "",
            	card: "",
            	expirationDate: "",
            	ccv: ""
            }
        }
    },

    created() {
        this.isLoading = true;
    },
     mounted() {
        this.isLoading = false;
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
			    		( this.sameAddress || this.validateAddress( this.selectedBillingAddress ) ) &&
			    		  this.validatePayment()
			    		 ){
				        proceed = true;
			    	}
			    	break;
			    // case 3:
			    // 	if( this.importFilter.section != null ){
			    // 		proceed = true;
			    // 	}
			    // 	break;
			    default:
			        proceed = false;
			}
			return proceed;
		}

    }
}
</script>