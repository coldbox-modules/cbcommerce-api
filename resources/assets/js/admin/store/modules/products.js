import get from "lodash/get";
import api from "../../api/index";

const initialState = {
	productsList         : [],
	currentProductID     : null,
	comparisonList       : [],
	wishList             : [],
	currentProductReviews: [],
	orderProductsList    : []
};

const getters = {
	productsList     : state => state.productsList,
	productsListArray: state => Object.values(state.productsList),
	currentProductID : state => state.currentProductID,
	currentProduct   : state => 
		get(state, ["productsList", state.currentProductID], null),
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
	getListOfProducts: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.products.list()
				.then(list => {
					// const products = get(list, "data", false);
					const products = list;
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
				.get.productReviews.list()
				.then(list => {
					const reviews = list;
					if(!reviews || reviews.length === 0){
						throw new Error("No reviews found");
					}
					commit( 'setProductReviewListItems', reviews );
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