<template>
    <div>
    	<div class="col-sm-9 block-form">
			<!-- Nav tabs -->
            <ul class="nav nav-pills  nav-justified">
                <li>
                	<a
                		href="#shipping"
                		data-toggle="tab">

                		<i class="fa fa-truck"></i>
                		Shipping
                	</a>
                </li>
                <li>
                	<a
                		href="#payment"
                		data-toggle="tab"
                		class="disabled">

                		<i class="fa fa-money"></i>
                		Payment
                	</a>
                </li>
                <li>
                	<a
                		href="#review"
                		data-toggle="tab"
                		class="disabled">

	                	<i class="fa fa-check"></i>
	                	Order Review
                	</a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div class="tab-pane active" id="shipping">
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
                                    <label for="inputPhone" class="control-label">Phone:<span class="text-error">*</span></label>
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
                                    <label for="inputAdress1" class="control-label">Address /1: <span class="text-error">*</span></label>
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
                                    <label for="inputCity" class="control-label">City: <span class="text-error">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputCity"
                                        	v-model="selectedShippingAddress.city">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputState" class="control-label">State/Province: <span class="text-error">*</span></label>
                                    <div>
                                        <input
                                        	type="text"
                                        	class="form-control"
                                        	id="inputState"
                                        	v-model="selectedShippingAddress.province">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputPostCode" class="control-label">Zip Code: <span class="text-error">*</span></label>
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
                    <button
                    	class="btn btn-default-1"
                    	:class="{ 'disabled' : !validateStep( 1 ) }">

                    	Next
                    </button>
                </div>

                <div class="tab-pane" id="payment">
                    <br>
                    Pay with your credit card via Stripe

                    <div class="row">
                    	<div class="col-md-6">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Name on Card:<span class="text-error">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="nameOnCard">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Card:<span class="text-error">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="card">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">Expiration Date:<span class="text-error">*</span></label>
                                <div>
                                    <input type="text" class="form-control" id="expireDate">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="inputFirstName" class="control-label">CCV:<span class="text-error">*</span></label>
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
							      <input type="checkbox"> Same as Shipping Address
							    </label>
							</div>
	                    <hr>
	                    <form role="form" method="post" action="#">
	                        <div class="row">
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label for="inputFirstName" class="control-label">First Name:<span class="text-error">*</span></label>
	                                    <div>
	                                        <input
	                                        	type="text"
	                                        	class="form-control"
	                                        	id="inputFirstName"
	                                        	>
	                                    </div>
	                                </div>
	                                <div class="form-group">
	                                    <label for="inputLastName" class="control-label">Last Name:<span class="text-error">*</span></label>
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
	                                    <label for="inputAdress1" class="control-label">Address /1: <span class="text-error">*</span></label>
	                                    <div>
	                                        <input type="text" class="form-control" id="inputAdress1">
	                                    </div>
	                                </div>

	                                <div class="form-group">
	                                    <label for="inputCity" class="control-label">City: <span class="text-error">*</span></label>
	                                    <div>
	                                        <input type="text" class="form-control" id="inputCity">
	                                    </div>
	                                </div>

	                                 <div class="form-group">
	                                    <label for="inputState" class="control-label">State/Province: <span class="text-error">*</span></label>
	                                    <div>
	                                        <input type="text" class="form-control" id="inputState">
	                                    </div>
	                                </div>

	                                <div class="form-group">
	                                    <label for="inputPostCode" class="control-label">Zip Code: <span class="text-error">*</span></label>
	                                    <div>
	                                        <input type="text" class="form-control" id="inputPostCode">
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                    </form>
                    </div>
                    <hr>
                    <a href="#" class="btn-default-1">Back</a>
                    <a href="#" class="btn-default-1">Next</a>
                </div>

                <div class="tab-pane" id="review">
                    <br>
                    <h3>Review</h3>
                    <br>
                    <div class="row">
                        <div class="col-md-12">
                            <div
				    			class="row cart-product-row"
				    			v-for="(product, index) in cartProducts"
					            :key="index">

    			<div class="col-sm-8">
    				<div class="cart-product">
	    				<div class="cart-product-image">
	    					<img
		                    :title="product.productName"
		                    :alt="product.productName"
		                    :src="product.image"
		                    class="image-responsive"/>
		                </div>
		                <div class="cart-product-text">
	    					<div class="cart-product-name">
	    						{{ product.productName }}
	    					</div>
	    					<div class="cart-product-actions">
	    						<ul class="list-inline">
	    							<li>
	    								<a href="#">Remove</a>
	    							</li>
	    						</ul>
	    					</div>
	    				</div>
	    			</div>
    			</div>
    			<div class="col-sm-2">
    				<div class="cart-product-price">
    					<span class="sr-only">unit price</span>{{ product.userPrice }}
    				</div>
    			</div>
    			<div class="col-sm-2">
    				<div class="cart-product-quantity">
    					<input
	                        type="number"
	                        value="1"
	                        class="form-control" />
	                </div>
    			</div>
    		</div>
                        </div>
                    </div>
                    <hr>
                    <a href="#" class="btn-default-1">Pay</a>
                </div>
            </div>
    	</div>

    	<div class="col-sm-3">
	     	<div class="cart-buy-box">
	     		<button class="btn btn-primary">Place Order</button><br/>
	     		By Placing your order, you agree to BSR's Privacy Notice.

		     	<div class="cart-summary">
		     		Order Summary
		     		<ul class="list-unstyled">
                        <li>Sub Total: <strong>$500.00</strong></li>
                        <li>Shipping &amp; Handling: <strong>$10.00</strong></li>
                        <li>Total Before Tax: <strong>$510.00</strong></li>
                        <li>Tax: <strong>$10.00</strong></li>
                        <li><hr></li>
                        <li class="active"><b>Order Total:</b> <strong>$520.00</strong></li>
                    </ul>
		     	</div>

		    </div>
	     </div>
    </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';

export default {
    directives: {
        imagesLoaded
    },
    data() {
        return {
            isLoading: false,
            selectedShippingAddress: {
            	firstName: "",
            	lastName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: "",
            	phone: ""
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
        ])
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

        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        },
        validateStep( step ){
			var proceed = false;

			switch( step ) {
			    case 1:
			    	for( var i in this.selectedShippingAddress ){
			    		if( this.selectedShippingAddress[ i ] == "" ){
				        	return proceed;
				        }
				        proceed = true;
			    	}
			    	break;
			    // case 2:
			    //     if( ( this.importFilter.startWith == 'year' && this.importFilter.year != null ) || ( this.importFilter.startWith == 'course' && this.importFilter.course != null ) ){
			    //     	proceed = true;
			    //     } else if( this.importFilter.startWith == 'all' && this.importFilter.section != null){
			    //     	proceed = true;
			    //     }
			    //     break;
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