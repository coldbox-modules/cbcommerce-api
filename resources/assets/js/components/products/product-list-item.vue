<template>

    <div>

        <div v-if="isLoading">
            <product-list-item-loading></product-list-item-loading>
        </div>

        <div v-if="!isLoading">

            <article class="product list">
                <div class="row">
                    <div class="col-xs-12 col-sm-4 col-md-4 text-center">
                        <figure class="figure-hover-overlay text-center">                                                                        
                            <a :href="`/store/product/${product.id}`" class="figure-href"></a>
                            <div v-if="this.isNew" class="product-new">new</div>
                            <div class="product-sale" v-if="product.startingPrice && product.startingPrice.basePrice < product.startingPrice.MSRP">{{ percentOff }} <br> off</div>

                            <a 
                                v-if="product.startingPrice"
                                @click="addItemToWishlist( { sku : product.startingPrice.SKU } )"
                                v-tooltip="{ content: $t('wishlist_add_item') }"
                                :title="$t('wishlist_add_item')"
                                class="product-wishlist"><i :class="$t('wishlist_icon')"></i></a>

                            <a 
                                @click="addItemToComparisonList( product.startingPrice.SKU )"
                                v-tooltip="{ content: $t('compare_this_item') }"
                                :title="$t('compare_this_item')"
                                class="product-compare"><i :class="$t('compare_icon')"></i></a>

                            <div class="product-item-image" v-if="productImageSrc.length" :style="`background-image:url(${productImageSrc})`"></div>
                            <div class="product-item-image-placeholder" v-else></div>

                        </figure>
                    </div>
                    <div class="col-xs-12 col-sm-8 col-md-8">
                        <div class="product-caption">
                        
                            <div class="block-name">
                                <a :href="`/store/product/${product.id}`" class="product-name">{{ removeHTML( product.name, 100 ) }}</a>

                                <div v-if="product.startingPrice && product.startingPrice.basePrice">
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

                            <div v-if="product.startingPrice && product.startingPrice.basePrice" class="product-cart">
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


                            <p class="description" v-html="product.shortDescription"></p>

                        </div>
                    </div>
                </div>
            </article>

        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import ProductListItemLoading from './product-list-item-loading';
import moment from "moment";
export default {
    components: {
        ProductListItemLoading
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
            "wishlistItems",
            "comparisonItems"
        ]),
        hasPricing(){
            return this.product.startingPrice && this.product.startingPrice.basePrice;
        },
        isNew(){
            return moment( new Date( this.product.createdTime ) ) > moment( new Date() ).subtract( "30 days" );
        },
        percentOff(){
            return parseInt( 100 * ( 1 - ( this.product.startingPrice.basePrice / this.product.startingPrice.MSRP ) ) );
        },
        productImageSrc(){
            var self = this;
            var mediaSrc = '';
            this.product.media.forEach( mediaItem => {
                if( !mediaSrc.length && self.isImage( mediaItem ) ){
                    mediaSrc = mediaItem.src;
                }
            });

            return mediaSrc;
        }
    },

    methods: {
        ...mapActions([
            "addItemToCart",
            "addItemToWishlist",
            "addItemToComparisonList"
        ]),
        isImage: function( mediaItem ){
            return this.$options.filters.isImage( mediaItem );
        },
        imageProgress: function( instance, image ){
            var result = image.src ? 'loaded' : 'broken';
        },
        removeHTML( html, truncateTo ){
            let textConversion = $( '<p>' + html + '</p>' ).text();
            if( truncateTo ){
                return this.$options.filters.truncate( textConversion, truncateTo );
            } else {
                return textConversion;
            }
        }
        

    }
}
</script>

<style>
    
</style>