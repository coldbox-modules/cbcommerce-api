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
                            <a :href="productLink" class="figure-href"></a>
                            <div v-if="this.isNew" class="product-new">new</div>
                            <div class="product-sale" v-if="this.percentOff">{{ this.percentOff }} <br> off</div>

                            <a 
                                @click="addProductToComparisonList(product)"
                                v-tooltip="{ content: 'Compare this item' }"
                                class="product-compare"><i class="fa fa-random"></i></a>

                            <a 
                                @click="addProductToWishlist(product)"
                                v-tooltip="{ content: 'Add this item to your wishlist' }"
                                class="product-wishlist"><i class="fa fa-heart-o"></i></a>

                            <div v-images-loaded:on.progress="imageProgress">
                                <img 
                                    :src="this.image" 
                                    class="img-overlay img-responsive" 
                                    :alt="this.name" />
                                <img 
                                    :src="this.image2" 
                                    class="img-responsive" 
                                    :alt="this.name" />
                            </div>

                        </figure>
                    </div>
                    <div class="col-xs-12 col-sm-8 col-md-8">
                        <div class="product-caption">
                        
                            <div class="block-name">
                                <a href="#" class="product-name">{{ this.name }}</a>

                                <div v-if="this.listPrice">
                                    <div v-if="this.userPrice" class="priceWithDiscount">
                                        <span>&dollar;{{ this.listPrice }}</span> &dollar;{{ this.userPrice }}
                                    </div>
                                    <div v-else>
                                        <p class="product-price">&dollar;{{ this.listPrice }}</p>
                                    </div>
                                </div>
                                <div v-else>
                                    <p class="product-price">&nbsp;</p>
                                </div>

                            </div>

                            <p class="description">
                                {{ this.description }}
                            </p>

                            <div v-if="this.listPrice" class="product-cart">
                                <a 
                                    @click="addItemToCart( { product, quantity: 1 } )"
                                    v-tooltip="'Add this item to your cart'"
                                    class="btn"><i class="fa fa-shopping-cart"></i> Add to cart</a>
                            </div>
                            <div v-else class="product-request">
                                <a href="#" 
                                    v-tooltip="'Request a quote for this item'"
                                    class="btn"><i class="fa fa-envelope"></i> Request quote</a>
                            </div>

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

    created: function(){
        this.parseContent();
    },

    data() {
        return {
            productLink: '/equipment/category/sub-category/test-product',
            isLoading  : true,
            name       : null,
            price      : null,
            userPrice  : null,
            percentOff : null,
            description: null,
            isNew      : false,
            image      : null,
            image2     : null
        }
    },

    mounted() {},

    computed: {
        ...mapGetters([
            "cartProducts",
            "wishlistProducts",
            "comparisonProducts"
        ])
    },

    methods: {

        ...mapActions([
            "addItemToCart",
            "addProductToWishlist",
            "addProductToComparisonList"
        ]),

        parseContent: function(){
            var self          = this;
            var parsedContent = self.product;
            self.name         = parsedContent.productName;
            self.listPrice    = parsedContent.listPrice;
            self.userPrice    = parsedContent.userPrice;
            self.percentOff   = parsedContent.percentOff;
            self.description  = parsedContent.description;
            self.isNew        = parsedContent.isNew;
            self.image        = parsedContent.image;
            self.image2       = parsedContent.image2;
            self.isLoading    = false;
        },

        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }

    },

    computed: {}
}
</script>

<style>
    
</style>