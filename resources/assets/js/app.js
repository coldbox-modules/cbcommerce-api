// Import our jQuery and Bootstrap extensions
import "bootstrap-sass/assets/javascripts/bootstrap.js";
import { WOW } from "wowjs/dist/wow.js";
import 'owl.carousel/dist/owl.carousel.min.js';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import VueCurrencyFilter from "vue-currency-filter";
import Vuex from 'vuex';

import createStore from "./store/index";
import createRouter from "./store/router";
import createFilters from "./filters/index";

Vue.component( "mediaOwlCarousel", require( "./components/media-owl-carousel" ).default );
Vue.component( "cbSlickSlider", require( "./components/cb-slick-slider" ).default );
Vue.component( "cbMediaGallery", require( "./components/cb-media-gallery" ).default );
Vue.component( "bsrFinanceCalculator", require( "./components/bsr-finance-calculator" ).default );

import App from "@cbCommerce/components/App";
import Router from "vue-router";

import { sync } from "vuex-router-sync";

const storeInstance = createStore(Vue, Vuex);
const routerInstance = createRouter(Vue, Router);

sync(storeInstance, routerInstance);


Vue.use( VueCurrencyFilter,
	{
		symbol            : '$',
		thousandsSeparator: ',',
		fractionCount     : 2,
		fractionSeparator : '.',
		symbolPosition    : 'front',
		symbolSpacing     : false
	}
);

export default new Vue({
    el: "#app",
    store: storeInstance,
    router: routerInstance,
    filters: createFilters(Vue),
    template: "<app/>",
    components: {
        App
    }
});

Vue.use( VueTruncate );
Vue.use( VTooltip );

new WOW().init();
