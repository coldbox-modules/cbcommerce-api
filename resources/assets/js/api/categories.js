export const getCategoryList = api => ( params ) => api.get('/product-categories', { params : params } );
export const createCategory = api => (data) => {
  const bodyParams = data;
  return api.post( '/product-categories', JSON.stringify(bodyParams) );
};

export const categories = api => ({
  get: {
    categories: {
    	list: getCategoryList(api)
    }
  },
  post: {
    categories: {
      save: createCategory(api)
    }
  }
});

export default categories;
