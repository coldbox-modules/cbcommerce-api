import createLogger from "vuex/dist/logger";

import products from "./modules/products";
import cart from "./modules/cart";

export const createStore = (Vue, Vuex) => {
	Vue.use(Vuex);
	const state = {};
	const debug =
    process.env.NODE_ENV !== "production" && process.env.NODE_ENV !== "test";

	return new Vuex.Store({
		state,
		modules: {
			products,
			cart
		},
		plugins: debug ? [createLogger()] : []
	});
};

export default createStore;