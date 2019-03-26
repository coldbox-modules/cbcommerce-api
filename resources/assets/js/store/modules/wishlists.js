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
	saveWishlistItem: ( context, params ) => api().put.wishlists.updateItem( params ),
	deleteWishlistItem: ( context, params ) => api().delete.wishlists.deleteItem( params.FK_wishlist, params.id ),
	getWishlists: ({ state, commit, getters }, params ) => {
		if( !getters.authUser ) return;
		return api()
			.get.wishlists.list( params )
			.then(XHR => {
				commit( "setWishLists", XHR.data );
			})
			.catch(err => {

			})
	},
	fetchWishlist : ({ state }, params ) => {
		if( !params.id ){
			var id = params;
			params = undefined;
		} else {
			var id = params.id;
			delete params.id;
		}
		return api().get.wishlists.get( id, params )
	},
	saveWishlist: ( { state, commit, getters }, data ) => !data.id 
															? api().post.wishlists.create( data ) 
															: api().put.wishlists.update( data ),
	deleteWishlist:( context, wishlistId ) => api().delete.wishlists.delete( wishlistId )

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
	appendWishlist( state, wishlist ){
		Vue.set( state.wishlists.resultsMap, wishlist.id, wishlist );
		if( state.wishlists.results.indexOf( wishlist.id ) === -1 ){
			state.wishlists.results.push( wishlist.id )
		}
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