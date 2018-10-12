<template>

    <div>

        <div class="col-md-12 productDetailHeader">

            <h1 
                class="wow fadeInRight animated animated" 
                data-wow-duration="1s">{{ this.productName }}</h1>

        </div>
        
        <div class="col-md-9">

            <div class="block-product-detail">

                <div class="row">

                    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">

                        <div 
                            v-images-loaded:on.progress="imageProgress"
                            class="product-image">

                            <img 
                                id="product-zoom" 
                                :src="this.productImage" 
                                :data-zoom-image="this.productImageLarge" 
                                :alt="this.productName" />

                            <div id="thumbnailNestedGallery">

                                <product-gallery-thumb
                                    v-for="(galleryItem, index) in productGallery"
                                    :key="index"
                                    :galleryItem="galleryItem"
                                    :totalThumbs="productGallery.length"
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
                                    :rating="this.avgRating"
                                ></star-rating>

                                <a href="" class="review">{{ this.totalReviews }} Reviews</a> 
                            </div>

                            <div class="clearfix">
                                <p class="product-price">{{ this.userPrice }}</p>
                            </div>

                            <div class="clearfix">
                                <label class="pull-left">List Price:</label>
                                <p class="product-list-price">{{ this.listPrice }}</p>
                            </div>

                            <div class="product-information">

                                <div class="clearfix">
                                    <p 
                                        class="availability"
                                        v-bind:class="{ active: this.inStock }">{{ availabilityText }}</p>
                                </div>

                                <div class="clearfix"> 
                                    <label class="pull-left">Brand:</label> {{ this.brand }}
                                </div>

                                <div class="clearfix"> 
                                    <label class="pull-left">Model:</label> {{ this.model }}
                                </div>

                                <div class="clearfix">
                                    
                                    <p 
                                        v-for="(feature, index) in this.features"
                                        :key="index"
                                        class="description">
                                        {{ feature }}
                                    </p>

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
                    <li><a href="#additional" data-toggle="tab" class="disabled">Additional</a></li>
                    <li><a href="#review" @click="fetchReviews" data-toggle="tab">Review</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="description">
                        <br>
                        <h3>Product Details</h3>
                        <hr>
                        <p>{{ this.details }}</p>
                    </div>
                    <div class="tab-pane" id="additional">
                        <br>
                        <h3>Additional Details</h3>
                        <hr>

                    </div>
                    <div class="tab-pane" id="review">
                        <br>
                        <div class="row">
                            <div class="col-md-12">
                                <h3>Clients review</h3>
                                <hr>
                                
                                <product-review
                                    v-for="(review, index) in this.currentProductReviews"
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
                    v-if="this.inStock"
                    v-on:quantityChange="quantityChangeReaction"
                ></quantity-control>

                <div class="product-cart-total-price clearfix">
                    <label class="pull-left">Total:</label>
                    <p>&dollar;{{this.cartTotalPrice}}</p>
                </div>

                <div v-if="this.inStock" class="shopping-cart-buttons">
                    <a 
                        @click="addProductToCart( { product, quantity: chosenQuantity } )"
                        v-tooltip="'Add this item to your cart'"
                        class="addToCart"><i class="fa fa-shopping-cart"></i> Add to cart</a>
                </div>

                <div class="shopping-cart-buttons mt-20">

                    <a 
                        @click="addProductToWishlist(product)"
                        v-tooltip="{ content: 'Add this item to your wishlist' }"
                        title="Wishlist"><i class="fa fa-heart-o"></i></a>

                    <a 
                        @click="addProductToComparisonList(product)"
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
import QuantityControl from './quantity-control';
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
            inStock          : null,
            brand            : null,
            model            : null,
            features         : null,
            details          : null,
            totalReviews     : null,
            avgRating        : null,
            cartTotalPrice   : null,
            relatedProducts  : null
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
            "cartProducts",
            "wishlistProducts",
            "comparisonProducts",
            "productsList",
            "productsListArray",
            "currentProductReviews"
        ]),

        availabilityText: function(){
            return ( this.inStock ) ? 'In Stock' : 'Out Of Stock';
        }

    },

    methods: {

        ...mapActions([
            "addProductToCart",
            "addProductToWishlist",
            "addProductToComparisonList",
            "setCurrentProduct",
            "getListOfProducts",
            "getCurrentProductReviews"
        ]),

        // TODO: this can be removed once the API and persistence is in place
        fetchProducts(){
            const self = this;
            Promise.resolve(this.getListOfProducts())
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
            fetch( 'mockData/productDetail.json' )
                .then(r => r.json())
                .then(product => {
                    self.product           = product;
                    self.productGallery    = product.gallery;
                    self.productImage      = product.productImage;
                    self.productImageLarge = product.productImageLarge;
                    self.productName       = product.productName;
                    self.userPrice         = product.userPrice;
                    self.listPrice         = product.listPrice;
                    self.inStock           = product.inStock;
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
        },

        fetchReviews: function(){
            const self = this;
            Promise.resolve(this.getCurrentProductReviews())
            .then(() => {})
            .catch(err => console.error(err));
        },

        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        },

        quantityChangeReaction: function( quantity = 1 ){
            const userPrice = this.userPrice.replace( "$", "" );
            this.chosenQuantity = quantity;
            this.cartTotalPrice = ( userPrice * quantity ).toFixed( 2 );
        }

    }
}
</script>