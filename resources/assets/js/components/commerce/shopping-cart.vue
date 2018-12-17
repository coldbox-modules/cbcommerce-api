<template>
     <div>
    	<div class="col-sm-9">
    		<div v-if="cartProducts && cartProducts.length == 0">
    			<h3>Your Shopping Cart is empty.</h3>
    			<p>Continue shopping <a href="/equipment/category">equipment</a>, smallwares or used equipment.</p>
    		</div>
    		<div
    			v-else
    			v-for="(item, index) in cartProducts"
    			:key="index">

    			<cart-item :item= "item">

    			</cart-item>
    		</div>
	     </div>
	     <div class="col-sm-3">
	     	<div class="cart-buy-box">
		     	<div class="cart-buy-subtotal">
		     		<span>Subtotal </span>
		     		<span class="text-muted">(
		     			<span>{{ totalItems }}</span>
		     			<span v-if="totalItems > 1">items</span>
		     			<span v-else>item</span>
		     				)
		     		</span><br/>
		     		<span>${{ subtotal }} </span>
		     	</div>
		     	<button class="btn btn-primary">Proceed to Checkout</button>
		    </div>
	     </div>


    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
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

    created() {
    },

    mounted() {
        this.isLoading = false;
    },

    destroyed() {},

    computed: {
        ...mapGetters([
            "currentProduct",
            "productsListArray",
            "productsList",
            "cartProducts",
            "wishlistProducts",
            "comparisonProducts"
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
        }
    },

    methods: {

        ...mapActions([
            "setCurrentProduct",
            "clearCurrentProduct",
            "getListOfProducts",
            "addItemToCart",
            "deleteCartItem",
            "addProductToWishlist",
            "addProductToComparisonList"
        ]),

        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';

        },
        // quantityChangeReaction: function( quantity = 1 ){
        //     Vue.set( this, "chosenQuantity", quantity );
        // }

    }

}

</script>