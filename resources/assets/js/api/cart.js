export const getCart = api => () => api.get( '/cart' );
export const addItem = api => ( item ) => api.post( '/cart/' + item.sku, JSON.stringify( { quantity : item.quantity } ) );
export const updateItem = api => ( item ) => api.put( '/cart/' + item.sku, JSON.stringify( { quantity : item.quantity } ) );
export const removeItem = api => ( itemId ) => api.delete( '/cart/' + itemId );

export const cart = api => ({
  get: {
    cart: {
    	get: getCart( api )
    }
  },
  post : {
    cart: {
      item: addItem( api )
    }
  },
  put: {
    cart: {
      item: updateItem( api )
    }
  },
  delete: {
    cart: {
      item: removeItem( api )
    }
  }
});

export default cart;
