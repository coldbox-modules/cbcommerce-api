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
	getListOfCustomers: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.customers.list()
				.then(list => {
					const customers = list;
					if(!customers || customers.length === 0){
						throw new Error("No customers found");
					}
					// Normalize
					const normCustomers = {};
					customers.forEach(p => {
						normCustomers[p.id] = p;
					});
					commit( 'setCustomerList', normCustomers );
					resolve(normCustomers);
				})
				.catch(err => {
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
	saveCustomer: ({ commit, state }, customer) => {
		new Promise((resolve, reject) => {
			api()
				.post.customers.save(customer)
				.then(customer => {
					console.log(customer);
					resolve(customer);
				})
				.catch(err => {
					console.log(err);
					reject("Error: Could not save the customer");
				});
		})
	}
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