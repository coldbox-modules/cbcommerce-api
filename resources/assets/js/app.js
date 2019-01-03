// Import our jQuery and Bootstrap extensions
import "bootstrap-sass/assets/javascripts/bootstrap.js";
import { WOW } from "wowjs/dist/wow.js";
import 'owl.carousel/dist/owl.carousel.min.js';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import VueCurrencyFilter from "vue-currency-filter";
import VeeValidate from "vee-validate";
import Vuex from 'vuex';

import createStore from "@cbCommerce/store/index";
import createRouter from "@cbCommerce/store/router";
import createFilters from "@cbCommerce/filters/index";

Vue.component( "mediaOwlCarousel", require( "@cbCommerce/components/media-owl-carousel" ).default );
Vue.component( "cbSlickSlider", require( "@cbCommerce/components/cb-slick-slider" ).default );
Vue.component( "cbMediaGallery", require( "@cbCommerce/components/cb-media-gallery" ).default );
Vue.component( "bsrFinanceCalculator", require( "@cbCommerce/components/bsr-finance-calculator" ).default );
Vue.component( "loginForm", require( "@cbCommerce/components/login-form" ).default );


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

Vue.use(VeeValidate);

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
