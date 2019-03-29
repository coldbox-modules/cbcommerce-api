export const getCategoryList = api => ( params ) => api.get('/product-categories', { params : params } );
export const createCategory = api => data => {
	const bodyParams = data;
	return api.post("/product-categories", JSON.stringify(bodyParams));
};
export const getCategory = api => ( id, params ) => api.get('/product-categories/' + id, { params: params || { includes : "children" } } );
export const updateCategory = api => (data) => {
  delete data.originalData;
  delete data.children;
  delete data.media;
  return api.put('/product-categories/' + data.id, JSON.stringify(data));
};
export const deleteCategory = api => (id) => api.delete('/product-categories/' + id);
export const trackCategoryView = api => (id) => api.post('/statistics/categories/' + id, JSON.stringify({}));
// Category Media
export const createCategoryMediaItem = api => (id, data) => api.post('/product-categories/' + id + '/media', JSON.stringify(data))
export const getCategoryMedia = api => ( id, params ) => api.get( '/product-categories/' + id + '/media', { params: params || {} } )
export const updateCategoryMediaItem = api => ( data ) => {
  delete data.originalData;
  delete data.FK_category;
  return api.put(data.href.replace('/store/api/v1', ''), JSON.stringify(data));
}
export const updateCategoryMediaItemField = api => ( href, field, fieldValue ) => {
  let payload = {};
  payload[ field ] = fieldValue;
  return api.patch(href.replace('/store/api/v1', ''), JSON.stringify( payload ) );
};
export const deleteCategoryMediaItem = api => (item) => api.delete( item.href.replace('/store/api/v1', '') );

export const categories = api => ({
  get: {
    categories: {
      list: getCategoryList(api),
      get : getCategory( api ),
      media : getCategoryMedia( api )
    }
  },
  post: {
    categories: {
      save: createCategory(api),
      createMedia: createCategoryMediaItem(api),
      viewed: trackCategoryView( api )
    }
  },
  put : {
    categories : {
      update : updateCategory(api),
      updateMedia : updateCategoryMediaItem(api)
    }
  },
  patch : {
    categories : {
      updateMediaField : updateCategoryMediaItemField(api)
    }
  },
  delete: {
    categories : {
      delete : deleteCategory(api),
      deleteMedia : deleteCategoryMediaItem(api)
    }
  }
});

export default categories;
