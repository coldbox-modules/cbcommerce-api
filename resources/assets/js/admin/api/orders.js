export const getOrdersList = api => () => fetch( '/mockData/admin/orders.json' ).then(r => r.json());

export const orders = api => ({
  get: {
    orders: {
    	list: getOrdersList(api)
    }
  }
});

export default orders;
