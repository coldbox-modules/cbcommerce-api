export const getCustomerList = api => ( params ) => api.get('/customers', { params : params} );
export const updateCustomer = api => ( data ) => data.id ? api.put( '/customers/' + data.id, JSON.stringify( data ) ) : api.post('/customers', JSON.stringify(data) );

export const customers = api => ({
  get: {
    customers: {
    	list: getCustomerList(api)
    }
  },
  post: {
    customers: {
      save: updateCustomer(api)
    }
  }
});

export default customers;