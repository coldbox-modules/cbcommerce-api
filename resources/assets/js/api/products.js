export const baseAPIHref = "/store/api/v1";
export const getProductsList = api => ( params ) => api.get( '/products', { params : params || undefined } );
export const createProduct = api => ( data ) => {
  const bodyParams = data;
  return api.post( '/products', JSON.stringify(bodyParams) );
};
export const updateProduct = api => ( data ) => {
  delete data.media;
  delete data.startingPrice;
  delete data.reviewSummary;
  data.includes = data.includes || "skus,categories";
  return api.put( data.href.replace(baseAPIHref, ''), JSON.stringify( data ) );
}

export const deleteProduct = api => ( id ) => api.delete( '/products/' + id )

export const getProduct = api => ( id, params ) => {
  return api.get( '/products/' + id, { params : params || { includes : "skus" } } );
};

export const trackProductView = api => ( id ) => api.post( '/statistics/products/' + id, JSON.stringify({}) );

export const getProductReviews = api => ( id, params ) => {
  return api.get( '/products/' + id + '/reviews', { params : params || null } );
};

export const getSkuWithProduct = api => ( sku ) => {
  return api.get( '/skus/' + sku, { params : { includes : "product" } } );
};


export const createSKU = api => ( data ) => api.post( '/skus', JSON.stringify( data ) );
export const updateSKU = api => ( data ) => {
  let payload = Object.assign( {}, data );
  delete payload.media;
  delete payload.originalData;
  delete payload.FK_condition;
  delete payload.FK_subCondition;
  return api.put( payload.href.replace(baseAPIHref, ''), JSON.stringify( payload ) ); 
}
export const deleteSKU = api => ( id ) => api.delete( '/skus/' + id );

// Product Media
export const createProductMediaItem = api => (id, data) => api.post('/products/' + id + '/media', JSON.stringify(data));
export const getProductMedia = api => (id, params) => api.get('/products/' + id + '/media', { params: params || {} });
export const updateProductMediaItem = api => (data) => {
  delete data.originalData;
  delete data.FK_product;
  return api.put(data.href.replace(baseAPIHref, ''), JSON.stringify(data));
}
export const updateProductMediaItemField = api => (href, field, fieldValue) => {
  let payload = {};
  payload[field] = fieldValue;
  return api.patch(href.replace(baseAPIHref, ''), JSON.stringify(payload));
};
export const deleteProductMediaItem = api => (item) => api.delete(item.href.replace(baseAPIHref, ''));

// Product SKU Media
export const createSKUMediaItem = api => (id, data) => api.post('/skus/' + id + '/media', JSON.stringify(data))
export const getSKUMedia = api => (id, params) => api.get('/skus/' + id + '/media', { params: params || {} })
export const updateSKUMediaItem = api => (data) => {
  delete data.originalData;
  delete data.FK_sku;
  return api.put(data.href.replace(baseAPIHref, ''), JSON.stringify(data));
}
export const updateSKUMediaItemField = api => (href, field, fieldValue) => {
  let payload = {};
  payload[field] = fieldValue;
  return api.patch(href.replace(baseAPIHref, ''), JSON.stringify(payload));
};
export const deleteSKUMediaItem = api => (item) => api.delete(item.href.replace(baseAPIHref, ''));


export const products = api => ( {
  get: {
    products: {
      list: getProductsList( api ),
      detail: getProduct( api ),
      media : getProductMedia( api )
    },
    skus : {
      getWithProduct : getSkuWithProduct( api ),
      media : getSKUMedia( api )
    },
    reviews: {
      list: getProductReviews( api )
    }
  },
  post: {
    products: {
      create: createProduct( api ),
      createMedia : createProductMediaItem( api ),
      viewed: trackProductView( api )
    },
    skus : {
      create : createSKU( api ),
      createMedia : createSKUMediaItem( api )
    }
  },
  put : {
    products : {
      update : updateProduct( api ),
      updateMedia : updateProductMediaItem( api )
    },
    skus : {
      update : updateSKU( api ),
      updateMedia : updateSKUMediaItem( api )
    }
  },
  patch: {
    products: {
      updateMediaField: updateProductMediaItemField(api)
    },
    skus : {
      updateMediaField : updateSKUMediaItemField(api)
    }
  },
  delete : {
    products : {
      delete : deleteProduct( api ),
      deleteMedia : deleteProductMediaItem( api )
    },
    skus : {
      delete : deleteSKU( api ),
      deleteMedia : deleteSKUMediaItem( api )
    }
  }
} );

export default products;
