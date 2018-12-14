import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	productsList         : [],
	currentProductID     : null,
	activeProduct        : null,
	comparisonList       : [],
	wishList             : [],
	currentProductReviews: []
};

const getters = {
	productsList     : state => state.productsList,
	productsListArray: state => Object.values(state.productsList),
	currentProductID : state => state.currentProductID,
	currentProduct   : state => 
		state.activeProduct || get(state, ["productsList", state.currentProductID], null),
	currentProductName: state => {
		const n = get(
			state,
			["productsList", state.currentProductID, "productName"],
			null
		);
		return n;
	},
	currentProductReviews: state => state.currentProductReviews,
	wishlistProducts: (state, getters) => {
		return state.wishList.map(({ id, quantity }) => {
			const product = get(state, ["productsList", id], null);
			return {
				product
			}
		})
	},
	comparisonProducts: (state, getters) => {
		return state.comparisonList.map(({ id, quantity }) => {
			const product = get(state, ["productsList", id], null);
			return {
				product
			}
		})
	},
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
	getCurrentProductReviews: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.reviews.list(productId)
				.then(XHR => {
					let list = XHR.data;
					const reviews = list;
					if (!reviews || reviews.length === 0) {
						throw new Error("No reviews found");
					}
					commit("setProductReviewListItems", reviews);
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
	},
	addProductToWishlist: ({ state, commit }, product) => {
		const wishlistItem = state.wishList.find( item => item.id === product.id );
		if( !wishlistItem ){
			commit( 'addProductToWishlist', { product: product, id: product.id } );
		}
	},
	addProductToComparisonList: ({ state, commit }, product) => {
		const wishlistItem = state.comparisonList.find(item => item.id === product.id);
		if( !wishlistItem ){
			commit( addProductToWishlist, { product: product, id: product.id } );
		}
	}
};

const mutations = {
	setActiveProduct( state, product ){
		state.currentProductID = product.id;
		state.activeProduct = product;
	},
	setProductList( state, list ){
		state.productsList = list;
	},
	setCurrentProduct( state, productID ){
		state.currentProductID = productID;
	},
	clearCurrentProduct( state ){
		state.currentProductID = null;
	},
	addProductToWishlist( state, { id, product } ){
		state.wishList.push({
			id,
			product
		})
	},
	setWishlistItems( state, { items } ){
		state.wishList = items;
	},
	addProductToWishlist( state, { id, product } ){
		state.comparisonList.push({
			id,
			product
		})
	},
	setComparisonListItems( state, { items } ){
		state.comparisonList = items;
	},
	setProductReviewListItems( state, list ){
		state.currentProductReviews = list;
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}