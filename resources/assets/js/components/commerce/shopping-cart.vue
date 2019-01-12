<template>
     <div>
     	<div v-if="isLoadingCart" class="overlay">
     		<generic-loader message="Your cart is loading. Please wait..."></generic-loader>
     	</div>
        <div v-else-if="cartProducts && !cartProducts.length" class="col-sm-12 text-center">
            <h3>Your Shopping Cart is empty.</h3>
            <p>Learn what's featuring today.</p>
            <p><a href="./" class="btn btn-lg btn-animate">Go to Homepage</a></p>
        </div>
        <div v-else>
	    	<div class="col-sm-9">
	    		<div
	    			v-for="(item, index) in cartProducts"
	    			:key="index">
	    			<cart-item :item= "item"></cart-item>
	    		</div>
		     </div>
		     <div class="col-sm-3">
		     	<div class="cart-buy-box text-center">
			     	<div class="cart-buy-subtotal">
			     		<span>Subtotal </span>
			     		<span class="text-muted">(
			     			<span>{{ totalItems }}</span>
			     			<span v-if="totalItems > 1">items</span>
			     			<span v-else>item</span>
			     				)
			     		</span><br/>
			     		<span>{{ subtotal | currency }} </span>
			     	</div>
			     	<a
			     		:href="checkoutURL"
			     		class="btn btn-animate btn-lg"
			     		:class="{ 'disabled': !cartProducts.length }">

			     		Proceed to Checkout
			     	</a>
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
        	isLoading: false
        }
    },
    mounted() {
        this.isLoading = false;
    },
    created() {},
    destroyed() {},

    computed: {
        ...mapState( {
    		globalData   : 'globalData'
    	}),
        ...mapGetters([
        	"isLoadingCart",
            "currentProduct",
            "productsListArray",
            "productsList",
            "cartProducts",
            "wishlistItems",
            "comparisonItems"
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
        totalItems(){
        	var total = 0;
        	for( var i in this.cartProducts ){
        		let qty = this.cartProducts[ i ].quantity;

        		total = total +  qty;
        	}
        	return total;
        },
        isLoggedIn(){
        	if( this.globalData && this.globalData.cbcAuthUser ){
        		return true;
        	} else {
        		return false;
        	}
        },
        checkoutURL(){
        	if( this.isLoggedIn ){
        		return '/store/checkout'
        	} else {
        		return '/store/checkout/login'
        	}
        }
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "addItemToCart",
            "deleteCartItem",
            "addItemToWishlist",
            "addItemToComparisonList"
        ]),

        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        }
    }

}

</script>