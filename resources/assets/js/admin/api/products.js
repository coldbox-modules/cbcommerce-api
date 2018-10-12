export const getProductsList = api => () => fetch( '/mockData/admin/products.json' ).then(r => r.json());

export const products = api => ({
  get: {
    products: {
    	list: getProductsList(api)
    }
  }
});

export default products;
