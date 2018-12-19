import createLogger from "vuex/dist/logger";
import VuexPersist from "vuex-persist";

import products from "@cbCommerce/store/modules/products";
import wishlists from "@cbCommerce/store/modules/wishlists";
import cart from "@cbCommerce/store/modules/cart";
import api from "@cbCommerce/api/index";


const vuexLocalStorage = new VuexPersist({
	key: 'cbCommerce', // The key to store the state on in the storage provider.
	storage: window.localStorage, // or window.localStorage or localForage
	// Function that passes the state and returns the state with only the objects you want to store.
	reducer: state => ( {
		productComparisonList: state.productComparisonList
	} )
})

export const createStore = (Vue, Vuex) => {
	Vue.use(Vuex);
	const state = {
		productComparisonList : []
	};
	const debug =
    process.env.NODE_ENV !== "production" && process.env.NODE_ENV !== "test";

	return new Vuex.Store({
		state,
		modules: {
			products,
			wishlists,
			cart
		},
		getters: {
			comparisonItems : state => state.productComparisonList
		},
		mutations: {
			setComparisonListItems(state, items ) {
				Vue.set( state, "productComparisonList", items );
			},
			addItemToComparisonList(state, sku) {
				state.productComparisonList.push(sku);
			}
		},
		actions: {
			addItemToComparisonList: ({ state, commit }, sku) =>
				new Promise((resolve, reject) => {
					const comparisonItem = state.productComparisonList.find(item => item.id === sku);
					if (!comparisonItem) {
						api()
							.get.skus.getWithProduct(sku)
							.then(XHR => {
								commit( "addItemToComparisonList", XHR.data );
								resolve(XHR.data);
							})
							.catch(err => {
								console.error(err);
								reject("Error: Could not retrieve a sku with the id " + sku);
							});
					} else {
						resolve();
					}
				}),
			removeItemFromComparisonList: ({ state, commit }, sku) => {
				if( !sku ) return;
				commit("setComparisonListItems", state.productComparisonList.filter( item => item.id !== sku ) )
			}
		},
		plugins: debug ? [ createLogger(), vuexLocalStorage.plugin ] : [ vuexLocalStorage.plugin ]
	});
};

export default createStore;