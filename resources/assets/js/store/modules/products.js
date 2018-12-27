import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	productsList         : [],
	currentProductID     : null,
	activeProduct        : null,
	currentProductReviews: []
};

const getters = {
	productsList      : state => state.productsList,
	productsListArray : state => Object.values(state.productsList),
	currentProductID  : state => state.currentProductID,
	currentProduct    : state => 
		state.activeProduct || get(state, ["productsList", state.currentProductID], null),
	currentProductName: state => {
		const n = get(
			state,
			["productsList", state.currentProductID, "productName"],
			null
		);
		return n;
	},
	currentProductReviews : state => state.currentProductReviews
};

const actions = {
	getProduct: ( { commit }, id ) => {
		commit( "setCurrentProduct", id );
		return new Promise((resolve, reject) => {
			api()
				.get.products.detail( id )
				.then( XHR => {
					commit('setActiveProduct', XHR.data);
					resolve( XHR.data );
				} )
				.catch( err => {
					console.error(err);
					reject("Error: Could retrieve a product with the id of " + id );
				} );
		} );
	},
	getCategoryProducts: ({ commit }, categoryId ) => new Promise( (resolve, reject) => {
		api()
			.get.products.list( { category : categoryId } )
			.then(XHR => {
				const products = Vue.options.filters.denormalize( XHR.data );
				if (!products || products.length === 0) {
					throw new Error("No products found");
				}
				// Normalize
				const normProducts = {};
				products.forEach(p => {
					normProducts[ p.id ] = p;
				});
				commit( 'setProductList', normProducts );
				resolve( normProducts );
			})
			.catch(err => {
				console.error(err);
				reject("Error: Could not resolve list of products");
			});
	}),
	getListOfProducts: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.products.list()
				.then( XHR => {
					let list = XHR.data;
					const products = Vue.options.filters.denormalize( list );
					if(!products || products.length === 0){
						throw new Error("No products found");
					}
					// Normalize
					const normProducts = {};
					products.forEach(p => {
						normProducts[p.id] = p;
					});
					commit( 'setProductList', normProducts );
					resolve(normProducts);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of products");
				});
		}),
	getProductReviews: ( context, productId ) =>
		new Promise((resolve, reject) => {
			api()
				.get.reviews.list( productId )
				.then(XHR => {
					let list = XHR.data;
					const reviews = Vue.options.filters.denormalize( list );
					if (!reviews || reviews.length === 0) {
						throw new Error("No reviews found");
					}
					context.commit( "setCurrentProductReviews", reviews);
					resolve(reviews);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of reviews");
				});
		}),
	setCurrentProduct: ({ commit }, productID) => {
		commit( 'setCurrentProduct', productID );
	},
	clearCurrentProduct: ({ commit }) => {
		commit( 'clearCurrentProduct' );
	}
};

const mutations = {
	setActiveProduct(state, product) {
		state.currentProductID = product.id;
		state.activeProduct = product;
	},
	setProductList(state, list) {
		state.productsList = list;
	},
	setCurrentProduct(state, productID) {
		state.currentProductID = productID;
	},
	clearCurrentProduct(state) {
		state.currentProductID = null;
	},
	setCurrentProductReviews(state, list) {
		state.currentProductReviews = list;
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}