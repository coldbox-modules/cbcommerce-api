export const getProductsList = api => () => api.get( '/products' );
export const createProduct = api => ( data ) => {
  const bodyParams = data;
  return api.post( '/products', JSON.stringify(bodyParams) );
};

export const getProduct = api => ( id ) => {
  return api.get( '/products/' + id, { params : { includes : "skus" } } )
};

export const getProductReviews = api => ( id, params ) => {
    return fetch( '/mockData/productReviews.json' );
};

export const getSkuWithProduct = api => ( sku ) => {
  return api.get( '/skus/' + sku, { params : { includes : "product" } } )
};

export const products = api => ( {
  get: {
    products: {
      list: getProductsList( api ),
      detail: getProduct( api )
    },
    skus : {
      getWithProduct : getSkuWithProduct( api )
    },
    reviews: {
      list: getProductReviews( api )
    }
  },
  post: {
    products: {
      save: createProduct( api )
    }
  }
} );

export default products;
