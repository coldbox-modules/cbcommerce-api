import get from "lodash/get";
import api from "@cbCommerce/api/index";
import { isContext } from "vm";

const initialState = {
	isAuthenticated : false,
	wishlists  : null,
	activeWishlist : null
};

const getters = {
	wishlistItems: (state, getters) => {
		if( !state.activeWishlist ) return;
		return state.activeWishlist.items;
	},
	defaultWishList: ( state, getters ) => {
		if( !state.wishlists ) return;
		var defaultWishlist = null;
		var defaults = state.wishlists.results.filter( wishlistId => state.wishlists.resultsMap[ wishlistId ].isDefault );
		if( defaults.length ){
			defaultWishlist = defaults[ 0 ];
		}
		return defaultWishlist;
	}
};

const actions = {
	addItemToWishlist: ({ state, commit, getters }, { sku, wishlist }) => {
		if( !state.isAuthenticated ) {
			Event.$emit( "cbCommerce.onAuthenticationRequired" );
			return;
		}
		if( !wishlist ) wishlist = getters.defaultWishList; 
		const wishlistItem = wishlist.items.find( item => item.id === sku.id );
		
		if (!wishlistItem) {
			api()
				.put.wishlists.update( wishlist.id, { sku : sku } )
				.then(XHR => {
					commit( "setWishlistData", XHR.data );
				})
				.catch(err => {
					console.error( err );
					reject( "Error: Could not update a wishlist with the id " + sku );
				});
			if( !wishlistItem ){
				commit( 'addItemToWishlist', { product: product, id: sku.id } );
			}
		}
	},
	getWishlists: ({ state, commit }) => new Promise((resolve, reject) => {
		api()
			.get.wishlists.list()
			.then(XHR => {
				commit( "setAuthenticated", true );
				commit( "setWishlists", XHR.data );
				resolve(XHR.data);
			})
			.catch(err => {
				commit( "setAuthenticated", false );
				console.error( err );
				reject( "Error: Could not retrieve wishlists" );
			});
	})
};

const mutations = {
	addItemToWishlist( state, { id, product } ){
		state.activeWishlist.push({
			id,
			product
		})
	},
	setWishlistItems( state, { items } ){
		state.activeWishlist = items;
	},
	setAuthenticated( state, authenticated ){
		state.isAuthenticated = authenticated;
	},
	addItemToWishlist( state, { id, product } ){
		state.comparisonList.push({
			id,
			product
		})
	},
	setWishlistData( state, data ){
		Vue.set( state.wishlists.resultMap, data.id, data );
		
		if (state.wishlists.results.indexOf(data.id) === -1) {
			state.wishlists.results.push(data.id);
		}
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}