export const getCategoryList = api => () => api.get('/product-categories');
export const createCategory = api => (data) => {
  const bodyParams = data;
  return api.post('/product-categories', JSON.stringify(bodyParams), {
    headers: { "Content-Type": "application/json" }
  });
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
