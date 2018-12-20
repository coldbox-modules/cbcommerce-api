<template>

    <div v-if="currentProduct">

        <div class="col-md-12 productDetailHeader">

            <h1 
                class="wow fadeInRight animated animated" 
                data-wow-duration="1s">{{ currentProduct.name }}</h1>

        </div>
        
        <div class="col-md-9">

            <div class="block-product-detail">

                <div class="row">

                    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">

                        <div 
                            v-images-loaded:on.progress="imageProgress"
                            class="product-image">

                            
                            <img 
                                v-if="currentProduct.media.length"
                                id="product-zoom" 
                                :src="currentProduct.media[ 0 ].href" 
                                :data-zoom-image="currentProduct.media[ 0 ].href" 
                                :alt="currentProduct.media[ 0 ].caption" />

                            <div id="thumbnailNestedGallery">

                                <product-gallery-thumb
                                    v-for="(mediaItem, index) in currentProduct.media"
                                    :key="index"
                                    :galleryItem="mediaItem"
                                    :totalThumbs="currentProduct.media.length"
                                    v-on:thumbLoaded="thumbLoadedResponse"
                                ></product-gallery-thumb>

                            </div>

                        </div>

                    </div>

                    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">

                        <div class="product-detail-section">

                            <div class="product-rating">

                                <star-rating 
                                    :show-rating="false"
                                    :item-size="10" 
                                    :read-only="true"
                                    :rating="avgRating"
                                ></star-rating>

                                <a href="" class="review">{{ totalReviews }} Reviews</a> 
                            </div>

                            <div class="clearfix">
                                <p class="product-price">{{ activeSku.basePrice | currency }}</p>
                            </div>

                            <div class="clearfix">
                                <label class="pull-left">List Price:</label>
                                <p class="product-list-price">{{ activeSku.MSRP | currency }}</p>
                            </div>

                            <div class="product-information">

                                <div class="clearfix">
                                    <p 
                                        class="availability"
                                        v-bind:class="{ active: isAvailable }">{{ availabilityText }}</p>
                                </div>

                                <div class="clearfix"> 
                                    <label class="pull-left">Brand:</label> {{ currentProduct.manufacturer }}
                                </div>

                                <div class="clearfix"> 
                                    <label class="pull-left">Model:</label> {{ activeSku.modelNumber }}
                                </div>

                                <div class="clearfix"> 
                                    <label>Summary:</label>
                                    <p v-html="currentProduct.shortDescription"></p>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- tab box -->

            <div class="box-border block-form" v-if="!isLoading">
                <!-- Nav tabs -->
                <ul class="nav nav-pills nav-justified">
                    <li class="active"><a href="#description" data-toggle="tab">Description</a></li>
                    <li><a href="#additional" data-toggle="tab">Additional</a></li>
                    <li><a href="#review" @click="fetchReviews" data-toggle="tab">Review</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="description">
                        <br>
                        <h3>Product Details</h3>
                        <hr>
                        <p>{{ currentProduct.description }}</p>
                    </div>
                    <div class="tab-pane" id="additional">
                        <br>
                        <h3>Additional Details</h3>
                        <hr>
                        <h4>Specifications:</h4>
                        <ul class="list-unstyled">
                            <li 
                                v-for="(spec, index) in activeSku.options.specifications"
                                :key="index"
                                class="description">
                                {{ spec }}
                            </li>
                        </ul>
                    </div>
                    <div class="tab-pane" id="review">
                        <br>
                        <div class="row">
                            <div class="col-md-12">
                                <h3>Clients review</h3>
                                <hr>
                                <product-review
                                    v-for="(review, index) in currentProductReviews"
                                    :key="index"
                                    :review="review"
                                ></product-review>

                            </div>
                        </div>
                        
                        <!-- Product review form -->
                        <product-review-form
                            v-on:reviewSubmission="reviewSubmissionReaction"
                        ></product-review-form>
                        <!-- End product review form -->

                    </div>

                </div>



            </div>

            <!-- end tab box -->
            <related-product-carousel></related-product-carousel>

        </div>

        <div class="col-md-3 product-detail-sidebar-section">

            <div class="product-information" v-if="!isLoading">

                <quantity-control 
                    :showLabel="false"
                    v-if="isAvailable"
                    v-on:quantityChange="quantityChangeReaction"
                ></quantity-control>

                <div class="product-cart-total-price clearfix">
                    <label class="pull-left">Total:</label>
                    <p>&dollar;{{cartTotalPrice}}</p>
                </div>

                <div v-if="isAvailable" class="shopping-cart-buttons">
                    <a 
                        @click="addItemToCart( { sku: activeSku.id, quantity: chosenQuantity } )"
                        v-tooltip="'Add this item to your cart'"
                        class="addToCart"><i class="fa fa-shopping-cart"></i> Add to cart</a>
                </div>

                <div class="shopping-cart-buttons mt-20">

                    <a 
                        @click="addItemToWishlist( { sku : activeSku.id } )"
                        v-tooltip="{ content: 'Add this item to your wishlist' }"
                        title="Wishlist"><i class="fa fa-heart-o"></i></a>

                    <a 
                        @click="addItemToComparisonList( activeSku.id )"
                        v-tooltip="{ content: 'Compare this item' }"
                        title="Compare"><i class="fa fa-random"></i></a>

                </div>

                <hr />

            </div>

        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import { StarRating } from 'vue-rate-it';
import "ez-plus/src/jquery.ez-plus.js";
import ProductGalleryThumb from './product-gallery-thumb';
import ProductReview from './product-review';
import QuantityControl from '@cbCommerce/components/admin/ui/quantity-control';
import ProductReviewForm from './product-review-form';
import RelatedProductCarousel from './related-product-carousel';
export default {
    components: {
        StarRating,
        ProductGalleryThumb,
        QuantityControl,
        ProductReview,
        ProductReviewForm,
        RelatedProductCarousel
    },
    directives: {
        imagesLoaded
    },
    data() {
        return {
            chosenQuantity   : 1,
            product          : null,
            isLoading        : false,
            thumbLoadCount   : 0,
            productGallery   : null,
            productImage     : null,
            productImageLarge: null,
            productName      : null,
            userPrice        : null,
            listPrice        : null,
            brand            : null,
            model            : null,
            features         : null,
            details          : null,
            totalReviews     : null,
            avgRating        : null,
            relatedProducts  : null,
            activeSkuId      : null
        }
    },

    created: function(){
        this.isLoading = true;
    },

    mounted() {
        // TODO: this can be removed once the API and persistence is in place
        this.fetchProducts();
        // Mocking an API delay
        window.setTimeout(
            this.fetchProductDetail,
            1000
        );

    },

    destroyed() {},

    computed: {

        ...mapGetters([
            "currentProduct",
            "cartProducts",
            "wishlistItems",
            "comparisonItems",
            "productsList",
            "productsListArray",
            "currentProductReviews"
        ]),
        isAvailable : function(){
            return this.activeSku.allowBackorder || this.activeSku.onHand;
        },
        availabilityText: function(){
            return ( this.activeSku.allowBackorder || this.activeSku.onHand ) ? 'In Stock' : 'Out Of Stock';
        },
        productId : () => {
            var locationParts = window.location.pathname.split( '/' );
            return locationParts[ locationParts.length - 1 ]; 
        },
        activeSku : function(){
            if( !this.currentProduct ) return;
            if( !this.activeSkuId ){
                return this.currentProduct.skus[ 0 ];
            } else {
                var self = this;
                let activeSkus = this.currentProduct.skus.filter( sku => sku.id === self.activeSkuId );
                if( activeSkus.length ) return activeSkus[ 0 ];
            }
        },
        cartTotalPrice : function(){
            return this.chosenQuantity * this.activeSku.basePrice;
        }
    },

    methods: {

        ...mapActions([
            "addItemToCart",
            "addItemToWishlist",
            "addItemToComparisonList",
            "setCurrentProduct",
            "getListOfProducts",
            "getCurrentProductReviews",
            "getProduct"
        ]),

        // TODO: this can be removed once the API and persistence is in place
        fetchProducts(){
            const self = this;
            Promise.resolve( this.getListOfProducts() )
            .then(() => {
                self.isLoading = false;
            })
            .catch(err => console.error(err));
        },

        reviewSubmissionReaction: function( reviewData ){
            // Here we would post the review to the API
            // but for now we'll append it to the array for mocking
            this.currentProductReviews.push( reviewData );
        },

        thumbLoadedResponse: function(){
            if( !this.productGallery ) return;
            this.thumbLoadCount++;
            if( this.thumbLoadCount == this.productGallery.length ){
                $( '#product-zoom' ).ezPlus( {
                    zoomType         : "inner",
                    cursor           : "crosshair",
                    zoomWindowFadeIn : 500,
                    zoomWindowFadeOut: 750,
                    borderSize       : 0
                } );
            }
        },

        fetchProductDetail: function(){
            var self    = this;
            self.isLoading = true;

            fetch( '/mockData/productDetail.json' )
                .then(r => r.json())
                .then(product => {
                    self.product           = product;
                    self.productGallery    = product.gallery;
                    self.productImage      = product.productImage;
                    self.productImageLarge = product.productImageLarge;
                    self.productName       = product.productName;
                    self.userPrice         = product.userPrice;
                    self.listPrice         = product.listPrice;
                    self.brand             = product.brand;
                    self.model             = product.model;
                    self.features          = product.features;
                    self.details           = product.details;
                    self.totalReviews      = product.totalReviews;
                    self.avgRating         = product.avgRating;
                    self.cartTotalPrice    = self.userPrice.replace( "$", "" );
                    self.isLoading         = false;
                    self.setCurrentProduct( product.id );
                })
            
            console.log( self.getProduct( self.productId ) );
        },

        fetchReviews: function(){
            const self = this;
            Promise.resolve( this.getCurrentProductReviews() )
            .then(() => {})
            .catch(err => console.error(err));
        },

        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        },

        quantityChangeReaction: function( {quantity, sku} ){
            if( !quantity ) quantity=1;
            Vue.set( this, "chosenQuantity", quantity );
        }

    }
}
</script>