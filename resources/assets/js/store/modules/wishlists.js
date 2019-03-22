import get from "lodash/get";
import api from "@cbCommerce/api/index";

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
	addItemToWishlist: ({ state, commit, getters }, { sku, wishlist } ) => {
		if( !getters.authUser) {
			return;
		}
		if( !wishlist ) wishlist = state.wishlists.resultsMap[ getters.defaultWishList ];
		
		const wishlistItem = wishlist.items.find( item => item.id === sku );

		console.log( sku );
		
		if (!wishlistItem) {
			api()
				.post.wishlists.addItem( wishlist.id, { sku : sku } )
				.then(XHR => {
					commit( "addItemToWishlist", XHR.data );
				})
				.catch(err => {
					console.error( err );
				});
		}
	},
	getWishlists: ({ state, commit, getters }, params ) => {
		if( !getters.authUser ) return;
		return api()
			.get.wishlists.list( params )
			.then(XHR => {
				commit( "setWishLists", XHR.data );
			})
			.catch(err => {

			})
	}
};

const mutations = {
	setWishlistItems( state, { items } ){
		state.activeWishlist = items;
	},
	addItemToWishlist( state, data ){
		state.wishlists.resultsMap[ data.FK_wishlist ].items.push( data );
	},
	setWishLists( state, resultsMap ){
		state.wishlists = resultsMap;
	},
	setWishlistData( state, data ){
		Vue.set( state.wishlists.resultsMap, data.id, data );
		
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