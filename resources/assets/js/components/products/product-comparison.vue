<template>

	<div class="box-border wow fadeInLeft animated" data-wow-duration="1s">

	    <table class="cart-table table compare">

	        <thead>

	            <tr class="card_product_name">
	                <th>Details</th>
	                <th 
	                	v-for="(product, index) in products"
	                	:key="index"
	                ><a href="/equipment/category/sub-category/test-product">{{ product.productName }}</a></th>
	            </tr>

	        </thead>

	        <tbody>

	            <tr>
	                <td class="card_product_image" data-th="Products">Images</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_image"
	                	:data-th="product.productName">
	                	<img 
                			:title="product.productName" 
                			:alt="product.productName" 
                			:src="product.image" />
	               	</td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Rating</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_rating"
	                	:data-th="product.productName">
	                    <div class="product-rating">

	                        <star-rating 
	                        	:inline="true"
                                :show-rating="false"
                                :item-size="10" 
                                :read-only="true"
                                :rating="product.avgRating"
                            ></star-rating>

	                    </div>
	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Description</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="product.productName">
	                	{{ product.description }}

	                	<p 
                            v-for="(feature, index) in product.features"
                            :key="index"
                            class="description">
                            {{ feature }}
                        </p>

	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Manufacturer</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="product.productName">
	                	{{ product.brand }}
	                </td>
	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Model</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="product.productName">
	                	{{ product.model }}
	                </td>
	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Availability</td>
	                
	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="product.productName">
	                	{{ availabilityText( product.inStock ) }}
	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Quantity</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	:data-id="index"
	                	:data-product-id="product.id"
	                	class="card_product_quantity"
	                	:data-th="product.productName">

		                <quantity-control 
		                	:componentID="'quantity_' + index"
		                    :showLabel="false"
		                    v-if="product.inStock && product.listPrice"
		                    v-on:quantityChange="quantityChangeReaction"
		                ></quantity-control>

	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Price</td>

	                <td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="product.productName">
	                    <div class="product">
	                        <div class="product-caption">
	                            <p class="product-price">&dollar;{{ product.userPrice }}</p>
	                        </div> 
	                    </div>
	                </td>
	            </tr>

	            <tr>
	            	<td></td>

	            	<td
	                	v-for="(product, index) in products"
	                	:key="index"
	                	class="card_product_add_to_cart"
	                	:data-th="product.productName">
	                	<div class="product">
	                        <div class="product-caption">

	                        	<a 
	                        		@click="addToCart"
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

	                        </div> 
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
import { StarRating } from 'vue-rate-it';
import QuantityControl from './quantity-control';
export default {
    components: {
        StarRating,
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
    		"wishlistProducts",
    		"comparisonProducts"
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

        // TODO: this can be removed once the API and persistence is in place
        fetchProducts() {
            const self = this;
            Promise.resolve(this.getListOfProducts())
            .then(() => {
                self.isLoading = false;
                // Mocking a limited result set here by slicing
                self.products = this.productsListArray.slice( 0, 2 );
            })
            .catch(err => console.error(err));
        },

        quantityChangeReaction( quantity = 1 ) {},

        addToCart( event ) {
			const productIndex = event.target.getAttribute( 'data-id' );
			const productID    = event.target.getAttribute( 'data-product-id' );
			const quantity     = $( '.qty', '#quantity_' + productIndex ).val();
			this.setCurrentProduct( productID );
			this.addProductToCart( { product: this.currentProduct, quantity } );
			this.clearCurrentProduct();
        }

    }

}

</script>