export const getCategoryList = api => () => fetch( '/mockData/categories.json' ).then(r => r.json());

export const categories = api => ({
  get: {
    categories: {
    	list: getCategoryList(api)
    }
  }
});

export default categories;
