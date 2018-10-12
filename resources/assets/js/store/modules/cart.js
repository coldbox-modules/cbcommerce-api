import get from "lodash/get";
import api from "@/api/index";

const initialState = {
	added         : [],
	checkoutStatus: null
};

const getters = {
	checkoutStatus: state => state.checkoutStatus,
	cartProducts: (state, getters, rootState) => {
		return state.added.map(({ id, quantity }) => {
			const product = get(rootState.products, ["productsList", id], null);
			return {
				title: product.productName,
				price: product.userPrice,
				quantity
			}
		})
	},
	cartTotalQuantity: (state, getters) => {
		return getters.cartProducts.reduce((total, product) => {
			return ( total + product.quantity )
		}, 0)
	},
	cartTotalPrice: (state, getters) => {
		return getters.cartProducts.reduce((total, product) => {
			return total + product.price * product.quantity;
		}, 0)
	}
};

const actions = {
	addProductToCart: ({ state, commit }, payload ) => {
		const product  = payload.product;
		const quantity = ( isNaN( payload.quantity ) ) ? 1 : payload.quantity;
		commit( 'setCheckoutStatus', null );
		// Could potentially check inventory status here before proceeding
		const cartItem = state.added.find(item => item.id === product.id);
		if( !cartItem ){
			commit( 'pushToCart', { product: product, id: product.id, quantity } );
		} else {
			commit( 'incrementItemQuantity', { cart_item: cartItem, quantity } );
		}
	}
};

const mutations = {
	pushToCart( state, { id, product, quantity } ){
		state.added.push({
			id,
			product,
			quantity: parseInt( quantity )
		})
	},
	setCheckoutStatus( state, status ){
		state.checkoutStatus = status;
	},
	incrementItemQuantity(state, { cart_item, quantity } ){
		const cartItem    = state.added.find(item => item.id === cart_item.id);
		cartItem.quantity = cartItem.quantity+parseInt( quantity );
	},
	setCartItems( state, { items } ){
		state.added = items;
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}