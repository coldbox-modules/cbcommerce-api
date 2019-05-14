<template>

	<div class="box-border">

	    <table class="cart-table table wow fadeInLeft animated">

	    	<thead>
	    		<tr>
	    			<td class="card_product_image">Image</td>
	    			<td class="card_product_name">Product Name</td>
	    			<td class="card_product_quantity">Quantity</td>
	    			<td class="card_product_price">Price</td>
	    			<td class="card_product_total">&nbsp;</td>
	    		</tr>
	    	</thead>

	    	<tbody>
	    		
	    		<tr
	    			v-for="(product, index) in products"
	                :key="index">

	    			<td class="card_product_image" data-th="Image">
	    				<img 
                			:title="product.productName" 
                			:alt="product.productName" 
                			:src="product.image" />
	    			</td>
	    			<td class="card_product_name" data-th="Product Name">
	    				{{ product.productName }}
	    			</td>
	    			<td class="card_product_quantity" data-th="Quantity">

	    				<quantity-control 
		                	:componentID="'quantity_' + index"
		                    :showLabel="false"
		                    v-if="product.inStock && product.listPrice"
		                    v-on:quantityChange="quantityChangeReaction"
		                ></quantity-control>

	    			</td>
	    			<td class="card_product_price" data-th="Unit Price">
	    				{{ product.userPrice | currency }}
	    			</td>
	    			<td class="card_product_add_to_cart" data-th="Add to Cart">

                    	<a 
                    		@click="addToCart( $event )"
                    		:data-id="index"
            				:data-product-id="product.id"
                    		v-if="product.inStock && product.listPrice"
                    		class="addToCart">
                    		<i class="fa fa-shopping-cart"></i> Add to cart
                    	</a>

                    	<div v-if="!product.listPrice" class="product-request">
	                    	<a 
	                    		href="#" 
	                    		class="btn">
	                    		<i class="fa fa-envelope"></i> Request quote
	                    	</a>
                    	</div>

	    			</td> 

	        	</tr>

	    	</tbody>

	    </table>

	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import QuantityControl from '@cbCommerce/admin/components/ui/quantity-control';
export default {
    components: {
        QuantityControl
    },
    directives: {
        imagesLoaded
    },
    data() {
        return {
			isLoading: false,
			products : null
        }
    },

    created() {
        this.isLoading = true;
    },

    mounted() {
    	this.fetchProducts();
    },

    destroyed() {},

    computed: {
        ...mapGetters([
        	"currentProduct",
        	"productsListArray",
            "productsList",
            "cartProducts",
            "wishlistItems",
            "comparisonItems"
        ])
    },

    methods: {

    	...mapActions([
    		"setCurrentProduct",
    		"clearCurrentProduct",
    		"getListOfProducts",
            "addItemToCart",
            "addItemToWishlist",
            "addItemToComparisonList"
        ]),

    	availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        },

        // TODO: this can be removed once the API and persistence is in place
        fetchProducts() {
            const self = this;
            Promise.resolve(this.getListOfProducts())
            .then(() => {
                self.isLoading = false;
                // Mocking a limited result set here by slicing
                self.products = this.productsListArray.slice( 1, 4 );
            })
            .catch(err => console.error(err));
        },

        quantityChangeReaction( {quantity, sku} ){},

        addToCart( event ){
			const productIndex = event.target.getAttribute( 'data-id' );
			const productID    = event.target.getAttribute( 'data-product-id' );
			const quantity     = $( '.qty', '#quantity_' + productIndex ).val();
			this.setCurrentProduct( productID );
			this.addItemToCart( { product: this.currentProduct, quantity } );
			this.clearCurrentProduct();
        }

    }

}

</script>