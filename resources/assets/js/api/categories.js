export const getCategoryList = api => ( params ) => api.get('/product-categories', { params : params } );
export const createCategory = api => (data) => {
  const bodyParams = data;
  return api.post( '/product-categories', JSON.stringify(bodyParams) );
};
export const getCategory = api => (id, params ) => api.get('/product-categories/' + id, { params: params || { includes : "children" } } );

export const categories = api => ({
  get: {
    categories: {
      list: getCategoryList(api),
      get : getCategory( api )
    }
  },
  post: {
    categories: {
      save: createCategory(api)
    }
  }
});

export default categories;
