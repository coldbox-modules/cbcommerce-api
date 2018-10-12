// export const getProductsList = api => () => api.get("/mockData/products.json");

export const getProductsList = api => () => fetch( 'mockData/products.json' ).then(r => r.json());
export const getProductReviews = api => () => fetch( 'mockData/productReviews.json' ).then(r => r.json());


export const products = api => ({
  get: {
    products: {
    	list: getProductsList(api)
    },
    productReviews: {
    	list: getProductReviews(api)
    }
  }
});

export default products;
