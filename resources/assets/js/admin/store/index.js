import createLogger from "vuex/dist/logger";
import auth from "@cbCommerce/store/modules/auth";
import categories from "@cbCommerce/store/modules/categories";
import customers from "@cbCommerce/store/modules/customers";
import orders from "@cbCommerce/store/modules/orders";
import products from "@cbCommerce/store/modules/products";
import createFilters from "@cbCommerce/filters/index";

createFilters(Vue);

export const createStore = (Vue, Vuex) => {
	Vue.use(Vuex);
	const state = {
		filters : Vue.options.filters,
		globalData: window.cbcGlobalData || {}
	};
	const debug =
    process.env.NODE_ENV !== "production" && process.env.NODE_ENV !== "test";

	return new Vuex.Store({
		state,
		modules: {
			auth,
			customers,
			categories,
			orders,
			products
		},
		plugins: debug ? [createLogger()] : []
	});
};

export default createStore;