export const util = api => ({
  post: {
    contactForm : ( data ) => api.post( '/contact-forms', data ),
    wishlistQuote : ( wishlistId, data ) => api.post( '/quote-request/wishlist/' + wishlistId, data ),
    cartQuote : ( cartId, data ) => api.post( '/quote-request/cart' ),
    skuQuote : ( skuId, data ) => api.post( '/quote-request/sku/' + skuId, data )
  }
});

export default util;
