// Import our jQuery and Bootstrap extensions
import "bootstrap-sass/assets/javascripts/bootstrap.js";
import { WOW } from "wowjs/dist/wow.js";
import 'owl.carousel/dist/owl.carousel.min.js';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import VueCurrencyFilter from "vue-currency-filter";
import VeeValidate from "vee-validate";
import Vuex from 'vuex';
import VueI18n from "vue-i18n";

import createStore from "@cbCommerce/store/index";
import createRouter from "@cbCommerce/store/router";
import createFilters from "@cbCommerce/filters/index";

// Import our cbCommerce components
import "@cbCommerce/global-components";

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

Vue.use(VueI18n);

// Create VueI18n instance with options
const messages = window.cbcGlobalData.i18n;
const i18n = new VueI18n({
    locale: window.cbcGlobalData.fwLocale, // set locale
    messages, // set locale messages
});

export default new Vue({
    el: "#app",
    i18n,
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