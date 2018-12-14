<template>
     <div>
    	<div class="col-sm-9">
    		<div
    			class="row cart-product-row"
    			v-for="(product, index) in cartProducts"
	            :key="index">

    			<div class="col-sm-7">
    				<div class="cart-product">
	    				<div class="cart-product-image">
	    					<a :href="`/store/product/${item.product.id}`">
	                            <img
	                                :title="item.product.name"
	                                :alt="item.product.name"
	                                :src="item.sku.image ? item.sku.image.href : item.product.image.href" />
	                        </a>
		                </div>
		                <div class="cart-product-text">
	    					<div class="cart-product-name">
	    						<a :href="'store/product/'+ product.product.id">{{ product.product.name }}</a>
	    					</div>
	    					<div class="cart-product-actions">
	    						<ul class="list-inline">
	    							<li>
	    								<a href="" @click.prevent="deleteCartItem( product.sku.id )">Remove</a>
	    							</li>
	    						</ul>
	    					</div>
	    				</div>
	    			</div>
    			</div>
    			<div class="col-sm-2">
    				<div class="cart-product-price">
    					<span class="sr-only">unit price</span>{{ product.sku.basePrice }}
    				</div>
    			</div>
    			<div class="col-sm-3">
    				<div class="cart-product-quantity">
		                <quantity-control
		                    :showLabel="false"
		                    :quantity="product.quantity"
		                    v-on:quantityChange="quantityChangeReaction"
		                ></quantity-control>
		            </div>
    			</div>
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
import QuantityControl from '../products/quantity-control';

export default {
	components: {
        QuantityControl
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
        quantityChangeReaction: function( quantity = 1 ){
            // Vue.set( this, "chosenQuantity", quantity );
            console.log( quantity );
        }

    }

}

</script>