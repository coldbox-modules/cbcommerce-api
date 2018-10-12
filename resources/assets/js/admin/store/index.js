import createLogger from "vuex/dist/logger";

import categories from "./modules/categories";
import customers from "./modules/customers";
import orders from "./modules/orders";
import products from "./modules/products";


export const createStore = (Vue, Vuex) => {
	Vue.use(Vuex);
	const state = {};
	const debug =
    process.env.NODE_ENV !== "production" && process.env.NODE_ENV !== "test";

	return new Vuex.Store({
		state,
		modules: {
			customers,
			categories,
			orders,
			products
		},
		plugins: debug ? [createLogger()] : []
	});
};

export default createStore;