export const getCustomerList = api => () => fetch( '/mockData/admin/customers.json' ).then(r => r.json());

export const customers = api => ({
  get: {
    customers: {
    	list: getCustomerList(api)
    }
  }
});

export default customers;
