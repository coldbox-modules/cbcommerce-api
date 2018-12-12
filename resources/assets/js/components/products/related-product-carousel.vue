<template>

    <div>

        <div class="header-for-light">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">
                {{ headerTitle }}
            </h1>

            <div class="toolbar-for-light" id="nav-related"></div>
        </div>

        <div :id="carouselId" class="owl-carousel">
            
            <product-item
                v-for="(product, index) in this.productsListArray"
                :key="index"
                :product="product"
            ></product-item>

        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Owl from "owl.carousel";
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
export default {
    components: {
        ProductItemLoading,
        ProductItem
    },
    props: {
        headerTitle: {
            default: 'You may also need',
            type   : String
        },
        carouselId: {
            type   : String,
            default: 'owl-related-products'
        },
        itemsOnStage: {             // items on screen
            type   : Number,
            default: 3
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
            default: "#nav-related"
        },
        showDots: {
            type   : Boolean,
            default: false
        },
        autoPlay: {
            type   : Boolean,
            default: false
        },
    },
    data() {
        return {
            fakes    : 3,
            products : null,
            isLoading: false,
        }
    },

    created() {
        this.isLoading = true;
        this.fetchRelatedProducts();
    },
    
    mounted() {
        this.$nextTick( function(){
            // this.installOwlCarousel();
        } );
    },

    destroyed() {},

    computed: {
        ...mapGetters([
            "productsListArray",
            "productsList",
            "currentProductID"
        ])
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

        fetchRelatedProducts(){
            const self = this;
            Promise.resolve(this.getListOfProducts())
            .then(() => {
                self.isLoading = false;
                self.installOwlCarousel();
            })
            .catch(err => console.error(err));
        }

    }
}
</script>