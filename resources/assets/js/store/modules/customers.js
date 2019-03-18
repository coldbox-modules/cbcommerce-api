import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	customerList     : [],
	currentCustomerID: null,
};

const getters = {
	customerList     : state => state.customerList,
	customerListArray: state => Object.values(state.customerList),
	currentCustomerID : state => state.currentCustomerID,
	currentCustomer   : state => 
		get(state, ["customerList", state.currentCustomerID], null),
};

const actions = {
	getListOfCustomers: (context, params) =>
		new Promise((resolve, reject) => {
			api()
				.get.customers.list( params )
				.then( XHR => {
					let results = XHR.data;
					const customers = context.rootState.filters.denormalize( results )
					// Normalize
					const normCustomers = {};
					customers.forEach(p => {
						normCustomers[p.id] = p;
					});
					context.commit( 'setCustomerList', normCustomers );
					resolve( results );
				})
				.catch( err => {
					console.error(err);
					reject("Error: Could not resolve list of customers");
				});
		}),
	setCurrentCustomer: ({ commit }, customerID) => {
		commit( 'setCurrentCustomer', customerID );
	},
	clearCurrentCustomer: ({ commit }) => {
		commit( 'clearCurrentCustomer' );
	},
	saveCustomer: ({ commit, state }, customer) => api().post.customers.save( customer )
};

const mutations = {
	setCustomerList( state, list ){
		state.customerList = list;
	},
	setCurrentCustomer( state, customerID ){
		state.currentCustomerID = customerID;
	},
	clearCurrentCustomer( state ){
		state.currentCustomerID = null;
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}