export const getCustomerList = api => () => api.get('/customers');
export const createCustomer = api => (data) => {
  const bodyParams = data;
  return api.post('/customers', JSON.stringify(bodyParams), {
    headers: { "Content-Type": "application/json" }
  });
};

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