<template>

	<div class="box-border wow fadeInLeft animated" data-wow-duration="1s">

	    <table v-if="comparisonItems.length" class="cart-table table compare">

	        <thead>

	            <tr class="card_product_name">
	                <th>Details</th>
	                <th 
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                >
					<a :href="`/store/product/${sku.product.id}`">
						{{ sku.product.name | removeHTML }}
					</a>
				</th>
	            </tr>

	        </thead>

	        <tbody>

	            <tr>
	                <td class="card_product_image" data-th="Products">Images</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_image"
	                	:data-th="sku.product.name">
							<a :href="`/store/product/${sku.product.id}`">
								<img 
									:title="sku.product.name" 
									:alt="sku.product.name" 
									:src="primaryImage( sku )" />
							</a>
	               	</td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Rating</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_rating"
	                	:data-th="sku.product.name">
	                    <div class="product-rating">

	                        <star-rating 
	                        	:inline="true"
                                :show-rating="false"
                                :item-size="10" 
                                :read-only="true"
                                :rating="sku.product.reviewSummary.averageRating"
                            ></star-rating>

	                    </div>
	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Description</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="sku.product.name">
						<h4>Description:</h4>
	                	{{ sku.product.shortDescription | removeHTML }}
						<h4>Specifications:</h4>
                        <ul class="list-unstyled">
                            <li 
                                v-for="(spec, index) in sku.options.specifications"
                                :key="index"
                                class="description">
                                {{ spec }}
                            </li>
                        </ul>
	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Manufacturer</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="sku.product.name">
	                	{{ sku.product.manufacturer }}
	                </td>
	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Model</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="sku.product.name">
	                	{{ sku.modelNumber }}
	                </td>
	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Availability</td>
	                
	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="sku.product.name">
	                	{{ availabilityText( sku ) }}
	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Quantity</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	:data-id="index"
	                	:data-product-id="sku.product.id"
	                	class="card_product_quantity"
	                	:data-th="sku.product.name">

		                <quantity-control 
							:sku="sku"
		                	:componentID="'quantity_' + index"
		                    :showLabel="false"
		                    v-if="inStock( sku ) && sku.basePrice"
		                    v-on:quantityChange="quantityChangeReaction"
		                ></quantity-control>

						<small><a href="javascript:;" @click="removeItemFromComparisonList( sku.id )">[ Remove Item ]</a></small>

	                </td>

	            </tr>
	            <tr>
	                <td class="card_product_image" data-th="Products">Price</td>

	                <td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_price"
	                	:data-th="sku.product.name | removeHTML">
	                    <div class="product">
	                        <div class="product-caption">
	                            <p class="product-price" v-if="sku.showPricing">{{ sku.basePrice | currency }}</p>
								<p class="text-muted" v-else>Available Upon Request</p>
	                        </div> 
	                    </div>
	                </td>
	            </tr>

	            <tr>
	            	<td></td>

	            	<td
	                	v-for="(sku, index) in comparisonItems"
	                	:key="index"
	                	class="card_product_add_to_cart"
	                	:data-th="sku.product.name">
	                	<div class="product">
	                        <div class="product-caption">

	                        	<a 
	                        		@click="addItemToCart( { sku: sku.id, quantity: sku.quantity || 1 } )"
	                        		:data-id="index"
	                				:data-product-id="sku.product.id"
	                        		v-if="sku.showPricing && inStock( sku )"
	                        		class="addToCart">
	                        		<i class="fa fa-shopping-cart"></i> Add to cart
	                        	</a>

								<div class="product-request" v-else>
			                    	<a 
			                    		@click="showSkuQuoteForm( sku.id )" 
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

		<table v-else class="cart-table table compare">
			<tr>
				<td>
					<h3>No items selected for comparison</h3>
					<p><a href="/">Continue Shopping</a></p>
				</td>
			</tr>
		</table>

        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>
	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import { StarRating } from 'vue-rate-it';
import QuantityControl from '@cbCommerce/admin/components/ui/quantity-control';
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';
export default {
	mixins : [ SkuQuoteMixin ],
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
			"addItemToComparisonList",
			"removeItemFromComparisonList"
        ]),
    	availabilityText( sku ){
            return this.inStock( sku ) ? 'In Stock' : 'Out Of Stock';
		},
		inStock( item ){
			let sku = this.getSkuFromList( item );
			if( !sku ) return false;
            return ( sku.onHand || sku.allowBackorder );
		},
		primaryImage( item ){
			let sku = this.getSkuFromList( item );
			if( !sku ) return;

			if( sku.media.length ){
				return sku.media[ 0 ].src;
			} else {
				return sku.product.media[ 0 ].src
			}
		},
		getSkuFromList( sku ){
			let filtered = this.comparisonItems.filter( item => item.id === sku.id );
			if( !filtered.length ) return;
			return filtered[ 0 ];
		},
		quantityChangeReaction: function( {quantity, sku} ){
			console.log( sku );
			let item = this.getSkuFromList( sku );
			if( !item ) return;
			Vue.set( item, "quantity", quantity );
		}

    }

}

</script>