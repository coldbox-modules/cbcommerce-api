import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	cart 		  : { "items" : [] },
	checkoutStatus: null
};

const getters = {
	checkoutStatus: state => state.checkoutStatus,
	cartProducts: state => state.cart.items,
	cartTotalQuantity: (state, getters) => {
		return getters.cartProducts.reduce( (total, item ) => {
			return ( total + item.quantity )
		}, 0)
	},
	cartTotalPrice: (state, getters) => {
		return getters.cartProducts.reduce( ( total, item ) => {
			return total + ( item.sku.basePrice * item.quantity );
		}, 0 )
	}
};

const actions = {
	getCart: ( context ) => {
		return new Promise( (resolve, reject) => {
			api().get.cart.get()
						.then( XHR => {
							context.commit( 'setCartItems', XHR.data );
							resolve( XHR.data );
						} )
						.catch( err => {
							console.error(err);
							reject( "Error: An error occurred while retrieving the cart" );
						});
		} );
	},
	addItemToCart: ( context, payload ) => {
		payload.quantity = ( isNaN( payload.quantity ) ) ? 1 : payload.quantity;
		context.commit( 'setCheckoutStatus', null );
		return new Promise((resolve, reject) => {
		api().put.cart.item( payload )
						.then(XHR => {
							context.commit( 'setCartItems', XHR.data );
							resolve( XHR.data );
						})
						.catch(err => {
							console.error(err);
							reject("Error: The sku with an id of " + payload.sku + " could not be added to the cart" );
						});
		});
	},
	updateCartItem: ( context, payload ) => {
		payload.quantity = (isNaN(payload.quantity)) ? 0 : payload.quantity;
		if( payload.quantity ){
			return new Promise((resolve, reject) => {
			api().put.cart.item( payload )
						.then(XHR => {
							context.commit( 'setCartItems', XHR.data );
							resolve( XHR.data );
						})
						.catch(err => {
							console.error(err);
							reject("Error: The sku with an id of " + payload.sku + " could not be updated in the cart" );
						});
			});
		} else {
			return context.dispatch( "deleteCartItem", payload.sku );
		}
	},
	deleteCartItem: ( context, sku ) => { 
		return new Promise((resolve, reject) => {
		api().delete.cart.item( sku )
						.then(XHR => {
							context.commit( 'removeCartItem', sku );
							resolve( XHR.data );
						})
						.catch(err => {
							console.error(err);
							reject("Error: The sku with an id of " + sku + " could not be removed from the cart" );
						});
		});
	}
};

const mutations = {
	removeCartItem( state, sku ){
		remaining = state.cart.items.forEach( item => {
			return item.sku.id !== sku;
		} );
		Vue.set( state.cart, "items", remaining );
	},
	setCheckoutStatus( state, status ){
		state.checkoutStatus = status;
	},
	setCartItems( state, { items } ){
		Vue.set( state.cart, "items", items );
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}