export const getOrdersList = api => () => api.get('/orders');
export const createOrder = api => (data) => {
  const bodyParams = data;
  return api.post('/orders', JSON.stringify(bodyParams) );
};

export const orders = api => ({
  get: {
    orders: {
    	list: getOrdersList(api)
    }
  },
  post: {
    orders: {
      save: createOrder(api)
    }
  }
});

export default orders;
