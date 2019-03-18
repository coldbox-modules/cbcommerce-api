export const getCustomerList = api => ( params ) => api.get('/customers', { params : params} );
export const createCustomer = api => ( data ) => api.post('/customers', JSON.stringify(data) );

export const customers = api => ({
  get: {
    customers: {
    	list: getCustomerList(api)
    }
  },
  post: {
    customers: {
      save: createCustomer(api)
    }
  }
});

export default customers;