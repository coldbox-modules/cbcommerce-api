<template>

    <div>

        <div v-if="!isLoading">

            <div class="text-center item">

                <article class="product light">
                    <figure class="figure-hover-overlay">                                                                        
                        <a :href="`/store/product/${product.id}`"  class="figure-href"></a>
                        <div v-if="isNew" class="product-new">new</div>
                        <div 
                            class="product-sale" 
                            v-if="product.startingPrice && product.startingPrice.basePrice < product.startingPrice.MSRP">{{ percentOff }}% <br> off</div>

                        <a 
                            @click="addProductToComparisonList(product)"
                            v-tooltip="{ content: 'Compare this item' }"
                            class="product-compare"><i class="fa fa-random"></i></a>

                        <a 
                            @click="addProductToWishlist(product)"
                            v-tooltip="{ content: 'Add this item to your wishlist' }"
                            class="product-wishlist"><i class="fa fa-heart-o"></i></a>
                        
                        <div>
                            <img 
                                v-for="mediaItem in product.media"
                                :key="mediaItem.id"
                                v-if="isImage( mediaItem )"
                                :src="mediaItem.href" 
                                class="img-overlay img-responsive" 
                                :alt="mediaItem.title" />
                            
                            <img 
                                v-if="product.media.length === 1 && isImage( product.media[ 0 ] )"
                                :src="product.media[ 0 ].href" 
                                class="img-responsive" 
                                :alt="product.media[ 0 ].title" />
                        </div>
                    </figure>
                    <div class="product-caption">
                        <div class="block-name">
                            <a href="#" class="product-name">{{ product.name }}</a>

                            <div v-if="product.startingPrice">
                                <div v-if="product.startingPrice.basePrice < product.startingPrice.MSRP" class="priceWithDiscount">
                                    <span>&dollar;{{ product.startingPrice.MSRP }}</span> &dollar;{{ product.startingPrice.basePrice }}
                                </div>
                                <div v-else>
                                    <p class="product-price">&dollar;{{ product.startingPrice.basePrice }}</p>
                                </div>
                            </div>
                            <div v-else>
                                <p class="product-price">&nbsp;</p>
                            </div>

                        </div>
                    </div>

                    <div v-if="product.startingPrice" class="product-cart">
                        <a 
                            @click="addItemToCart( { sku: product.startingPrice.SKU, quantity: 1 } )"
                            v-tooltip="'Add this item to your cart'"
                            class="btn"><i class="fa fa-shopping-cart"></i> Add to cart</a>
                    </div>
                    <div v-else class="product-request">
                        <a href="#" 
                            v-tooltip="'Request a quote for this item'"
                            class="btn"><i class="fa fa-envelope"></i> Request quote</a>
                    </div>

                    <p class="description">
                        {{ product.description | truncate( 35 ) }}
                    </p>

                </article>

            </div>

        </div>

        <div v-if="isLoading">
            <product-item-loading></product-item-loading>
        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import ProductItemLoading from './product-item-loading';
import moment from "moment";
export default {
    components: {
        ProductItemLoading
    },
    directives: {
        imagesLoaded
    },
    props: [
        'product'
    ],
    data() {
        return {
            isLoading  : false
        }
    },

    created: function(){
        this.isLoading = true;
    },

    mounted() {
        this.isLoading = false;
    },

    computed: {
        ...mapGetters([
            "cartProducts",
            "wishlistProducts",
            "comparisonProducts"
        ]),
        isNew(){
            return moment( new Date( this.product.createdTime ) ) < moment( new Date() ).add( "30 days" );
        },
        percentOff(){
            return parseInt( 100 * ( 1 - ( this.product.startingPrice.basePrice / this.product.startingPrice.MSRP ) ) );
        }
    },

    methods: {
        ...mapActions([
            "addItemToCart",
            "addProductToWishlist",
            "addProductToComparisonList"
        ]),
        isImage: function( mediaItem ){
            return this.$options.filters.isImage( mediaItem );
        },
        imageProgress: function( instance, image ){
            var result = image.href ? 'loaded' : 'broken';
        }

    }
}
</script>

<style>
    
</style>