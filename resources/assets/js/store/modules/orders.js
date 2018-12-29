import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	ordersList      : [],
	currentOrderID  : null,
	orderProductList: []
};

const getters = {
	ordersList           : state => state.ordersList,
	ordersListArray      : state => Object.values(state.ordersList),
	orderProductList     : state => state.orderProductList,
	orderProductListArray: state => Object.values(state.orderProductList),
	currentOrderID       : state => state.currentOrderID,
	currentOrder         : state => 
		get(state, ["ordersList", state.currentOrderID], null),
	currentOrderName: state => {
		const n = get(
			state,
			["ordersList", state.currentOrderID, "productName"],
			null
		);
		return n;
	},
};

const actions = {
	getListOfOrders: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.orders.list()
				.then(list => {
					const orders = get(list, "data", false);
					if(!orders || orders.length === 0){
						throw new Error("No orders found");
					}
					// Normalize
					const normOrders = {};
					orders.results.forEach(p => {
						normOrders[p.id] = p;
					});
					commit( 'setOrdersList', normOrders );
					resolve(normOrders);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of orders");
				});
		}),
	setCurrentOrder: ({ commit }, orderID) => {
		commit( 'setCurrentOrder', orderID );
	},
	clearCurrentOrder: ({ commit }) => {
		commit( 'clearCurrentOrder' );
	},
	clearOrderProductList: ({ commit }) => {
		commit( 'clearOrderProductList' );
	},
	addProductToOrder: ({ state, commit }, payload ) => {
		const productSKU = payload.productSKU;
		const product    = payload.product;
		const quantity   = ( isNaN( payload.quantity ) ) ? 1 : payload.quantity;
		const cartItem   = state.orderProductList.find( item => item.id === productSKU.id );
		if( !cartItem ){
			commit( 'pushProductToOrderList', { product: product, productSKU: productSKU, id: productSKU.id, quantity } );
		} else {
			commit( 'incrementItemQuantity', { cart_item: cartItem, quantity } );
		}
	},
	defineProductQuantity: ({ state, commit }, payload ) => {
		const product  = payload.product;
		const quantity = ( isNaN( payload.quantity ) ) ? 1 : payload.quantity;
		const cartItem = state.orderProductList.find( item => item.id === product.id );
		if( !cartItem ){
			commit( 'pushProductToOrderList', { product: product, id: product.id, quantity } );
		} else {
			commit( 'setProductQuantity', { cart_item: cartItem, quantity } );
		}
	},
	updateSKUBasePrice: ({ state, commit }, payload ) => {
		const cartItem = state.orderProductList.find( item => item.id === payload.parentId );
		if( cartItem ){
			commit( 'setProductBasePrice', { cart_item: cartItem, newPrice: payload.newPrice  } );
		}
	},
	saveOrder: ({ commit, state }, order) => {
		new Promise((resolve, reject) => {
			api()
				.post.orders.save(order)
				.then(order => {
					console.log(order);
					resolve(order);
				})
				.catch(err => {
					console.log(err);
					reject("Error: Could not save the order");
				});
		})
	}
};

const mutations = {
	setOrdersList( state, list ){
		state.ordersList = list;
	},
	setCurrentOrder( state, orderID ){
		state.currentOrderID = orderID;
	},
	clearCurrentOrder( state ){
		state.currentOrderID = null;
	},
	clearOrderProductList( state ){
		state.orderProductList = [];
	},
	pushProductToOrderList( state, { id, product, productSKU, quantity } ){
		state.orderProductList.push({
			id,
			product,
			productSKU,
			quantity: parseInt( quantity )
		})
	},
	incrementItemQuantity( state, { cart_item, quantity } ){
		const cartItem    = state.orderProductList.find(item => item.id === cart_item.id);
		cartItem.quantity = cartItem.quantity+parseInt( quantity );
	},
	setProductQuantity( state, { cart_item, quantity } ){
		const cartItem    = state.orderProductList.find(item => item.id === cart_item.id);
		cartItem.quantity = parseInt( quantity );
	},
	setProductBasePrice( state, { cart_item, newPrice } ){
		const cartItem                = state.orderProductList.find(item => item.id === cart_item.id);
		cartItem.productSKU.basePrice = parseInt( newPrice );
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}