<template>

    <div>

        <product-grid-loading :itemsOnStage="itemsOnStage"  v-if="isLoading"></product-grid-loading>

        <div :id="carouselId" class="owl-carousel">
            
            <product-item
                v-for="(product, index) in this.productsListArray"
                :key="index"
                :product="product"
                 v-on:quote-sku="showSkuQuoteForm"
            ></product-item>

        </div>

        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Owl from "owl.carousel";
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
import ProductGridLoading from "@cbCommerce/components/products/product-grid-loading";
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';

export default {
    mixins : [ SkuQuoteMixin ],
    components: {
        ProductItemLoading,
        ProductItem,
        ProductGridLoading
    },

    props: {
        carouselId: {
            type   : String,
            default: 'owl-bestseller'
        },
        itemsOnStage: {             // items on screen
            type   : Number,
            default: 4
        },
        loop: {
            type   : Boolean,
            default: false
        },
        margin: {                   // right marging of each item
            type   : Number,
            default: 4
        },
        showNav: {                  // show nav's prev and next buttons
            type   : Boolean,
            default: false
        },
        navContainer: {             // the nav container element
            type   : String,
            default: "#nav-bestseller"
        },
        showDots: {
            type   : Boolean,
            default: false
        },
        autoPlay: {
            type   : Boolean,
            default: false
        },
        listParams: {
            type : Object,
            required : false
        }
    },

    data() {
        return {
            fakes    : 4,
            products : null,
            isLoading: false,
        }
    },

    created() {
        this.isLoading = true;
        // Fetch the products
        this.fetchProducts();
    },
    computed: {
        ...mapGetters(
            [
                "productsListArray",
                "productsList",
                "currentProductID"
            ]
        )
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart"
        ]),

        installOwlCarousel(){
            $( '#' + this.carouselId ).owlCarousel( 
                { 
                    loop      : this.loop,
                    items     : this.itemsOnStage,
                    margin    : this.margin,
                    responsive:{
                        0:{
                            items:1
                        },
                        600:{
                            items:this.itemsOnStage - 1
                        },
                        1000:{
                            items:this.itemsOnStage
                        }
                    },
                    responsiveRefreshRate: 200,
                    autoplay             : this.autoPlay,
                    dots                 : this.showDots,
                    navText              : [ 
                        '<i class="fa fa-angle-left"></i>',
                        '<i class="fa fa-angle-right"></i>'
                    ],
                    navElement  : 'a',
                    nav         : this.showNav,
                    navContainer: this.navContainer
                }
            );
        },

        fetchProducts(){
            const self = this;
            Promise.resolve( this.getListOfProducts( this.listParams ) )
            .then( () => {
                Vue.set( self, "isLoading", false );
                self.installOwlCarousel();
            } )
            .catch( err => console.error(err) );
        }

    }
}
</script>