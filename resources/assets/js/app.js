// Import our jQuery and Bootstrap extensions
import "bootstrap-sass/assets/javascripts/bootstrap.js";
import { WOW } from "wowjs/dist/wow.js";
import 'owl.carousel/dist/owl.carousel.min.js';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import Vuex from 'vuex';

import createStore from "./store/index";
import createFilters from "./filters/index";

Vue.component( "mediaOwlCarousel", require( "./components/media-owl-carousel" ).default );
Vue.component( "cbSlickSlider", require( "./components/cb-slick-slider" ).default );
Vue.component( "cbMediaGallery", require( "./components/cb-media-gallery" ).default );
Vue.component( "bsrFinanceCalculator", require( "./components/bsr-finance-calculator" ).default );

import CategoryGrid from "./components/categories/category-grid";
import ProductCarousel from "./components/products/product-carousel";
import ProductFilterPage from "./components/products/product-filter-page";
import ProductDetail from "./components/products/product-detail";
import ContactForm from "./components/contact-form";
import ProductComparison from "./components/products/product-comparison";
import ProductWishlist from "./components/products/product-wishlist";
import ShoppingCart from "./components/commerce/shopping-cart";
import NavCart from "./components/ui/nav-cart";

if ( document.getElementById( "app" ) ) {

    const storeInstance = createStore( Vue, Vuex );

    new Vue( {
        el        : "#app",
        store     : storeInstance,
        filters   : createFilters( Vue ),
        components: {
    		CategoryGrid,
    		ProductCarousel,
    		ProductFilterPage,
    		ProductDetail,
    		ContactForm,
            ProductComparison,
            ProductWishlist,
            ShoppingCart,
            NavCart
    	}
    } );

    Vue.use( VueTruncate );
    Vue.use( VTooltip );

    new WOW().init();

}

// Fix header
$(function() {
        //Keep track of last scroll
        var lastScroll = 0;
        var header = $("#header");
        var headerfixed = $("#header-main-fixed");
        var headerfixedbg = $(".header-bg");
        var headerfixedtopbg = $(".top-header-bg");
        $(window).scroll(function() {
            //Sets the current scroll position
            var st = $(this).scrollTop();
            //Determines up-or-down scrolling
            if (st > lastScroll) {

                //Replace this with your function call for downward-scrolling
                if (st > 50) {
                    header.addClass("header-top-fixed");
                    header.find("#logo-default").addClass("dis-n");
                    header.find("#logo-alt").removeClass("hidden-lg");
                    headerfixedbg.addClass("header-bg-fixed");
                    headerfixed.addClass("header-main-fixed");
                    headerfixedtopbg.addClass("top-header-bg-fix");
                }
            }
            else {
                //Replace this with your function call for upward-scrolling
                if (st < 50) {
                    header.removeClass("header-top-fixed");
                    header.find("#logo-default").removeClass("dis-n");
                    header.find("#logo-alt").addClass("hidden-lg");
                    headerfixed.removeClass("header-main-fixed");
                    headerfixedbg.removeClass("header-bg-fixed");
                    headerfixedtopbg.removeClass("top-header-bg-fix");
                    //headerfixed.addClass("header-main-fixed")
                }
            }
            //Updates scroll position
            lastScroll = st;
        });
    });