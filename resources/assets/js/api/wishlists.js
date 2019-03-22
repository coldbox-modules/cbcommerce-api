export const getWishlists = api => ( params ) => api.get( '/wishlists', { params : params || undefined } );
export const getWishlist = api => ( id ) => api.get( '/wishlists/' + id );
export const getWishlistItems = api => (wishlistId) => api.get('/wishlists/' + wishlistId + '/items');
export const getWishlistItem = api => (wishlistId, id) => api.get('/wishlists/' + wishlistId + '/items/' + id);

export const createWishlist = api => ( data ) => {
  const bodyParams = data;
  return api.post('/wishlists', JSON.stringify( bodyParams ) );
};
export const updateWishlist = api => ( id, data ) => api.put( '/wishlists/' + id, JSON.stringify( data ) );
export const deleteWishlist = api => ( id ) => api.delete('/wishlists/' + id);

export const addWishlistItem = api => ( wishlistId, data ) => api.post( '/wishlists/' + wishlistId + '/items', JSON.stringify(data) );
export const deleteWishlistItem = api => ( wishlistId, id ) => api.delete( '/wishlists/' + wishlistId + '/items/' + id );

export const wishlists = api => (
  {
    get: {
      wishlists: {
        list  : getWishlists( api ),
        get   : getWishlist( api ),
        items : getWishlistItems( api ),
        item  : getWishlistItem( api )
      }
    },
    put : {
      wishlists: {
        update : updateWishlist( api )
      }
    },
    post: {
      wishlists: {
        save : createWishlist( api ),
        addItem : addWishlistItem( api )
      }
    },
    delete: {
      wishlists: {
        delete : deleteWishlist( api ),
        deleteItem : deleteWishlistItem( api )
      }
    }
  }
);

export default wishlists;
