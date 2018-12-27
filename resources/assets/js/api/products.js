export const getProductsList = api => ( params ) => api.get( '/products', { params : params || undefined } );
export const createProduct = api => ( data ) => {
  const bodyParams = data;
  return api.post( '/products', JSON.stringify(bodyParams) );
};

export const getProduct = api => ( id ) => {
  return api.get( '/products/' + id, { params : { includes : "skus" } } );
};

export const getProductReviews = api => ( id, params ) => {
  return api.get( '/products/' + id + '/reviews', { params : params || null } );
};

export const getSkuWithProduct = api => ( sku ) => {
  return api.get( '/skus/' + sku, { params : { includes : "product" } } );
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
