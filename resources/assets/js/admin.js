// Import our jQuery and Bootstrap extensions
import "bootstrap/dist/js/bootstrap.js";
import BootstrapVue from 'bootstrap-vue';
import PrettyCheckbox from 'pretty-checkbox-vue';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import { VueSlideoutPanel } from 'vue2-slideout-panel';
import VoerroTagsInput from '@voerro/vue-tagsinput';
import Grid from 'vue-js-grid'
import VueCurrencyFilter from 'vue-currency-filter'
import VueCharts from 'vue-chartjs'

// Module components
import PageHeader from '@/components/admin/ui/page-header';
import BackButton from '@/components/admin/ui/back-button';
import TablePagination from '@/components/admin/ui/table-pagination';
import DismissableAlert from '@/components/admin/ui/dismissable-alert';

import Vuex from 'vuex';
import Router from 'vue-router';

import { sync } from 'vuex-router-sync';

import createStore from "@/admin/store";
import createRouter from "@/admin/router";
import createFilters from "@/admin/filters";

import App from "@/admin/App";

const storeInstance  = createStore( Vue, Vuex );
const routerInstance = createRouter( Vue, Router );

sync( storeInstance, routerInstance );

Vue.use( VueTruncate );
Vue.use( VTooltip );
Vue.use( PrettyCheckbox );
Vue.use( BootstrapVue );
Vue.use( Grid );
Vue.use( VueCharts );

Vue.component( 'slideout-panel', VueSlideoutPanel );
Vue.component( 'tags-input', VoerroTagsInput );
Vue.component( 'page-header', PageHeader );
Vue.component( 'back-button', BackButton );
Vue.component( 'table-pagination', TablePagination );
Vue.component( 'dismissable-alert', DismissableAlert );

Vue.use( VueCurrencyFilter,
	{
		symbol            : '$',
		thousandsSeparator: ',',
		fractionCount     : 2,
		fractionSeparator : '.',
		symbolPosition    : 'front',
		symbolSpacing     : false
	}
)

const commerceAdmin = new Vue( {
	el        : "#app",
	store     : storeInstance,
	router    : routerInstance,
	filters   : createFilters( Vue ),
	template  : "<app/>",
	components: { App }
} );

export default commerceAdmin;