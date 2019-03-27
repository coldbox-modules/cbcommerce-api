export const getCart = api => () => api.get( '/cart' );
export const addItem = api => ( item ) => api.post( '/cart/' + item.sku, JSON.stringify( { quantity : item.quantity } ) );
export const removeItem = api => ( itemId ) => api.delete( '/cart/' + itemId );

export const cart = api => ({
  get: {
    cart: {
    	get: getCart( api )
    }
  },
  put: {
    cart: {
      item: addItem( api )
    }
  },
  delete: {
    cart: {
      item: removeItem( api )
    }
  }
});

export default cart;
