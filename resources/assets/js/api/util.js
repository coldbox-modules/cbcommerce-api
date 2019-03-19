export const util = api => ({
  post: {
    contactForm : ( data ) => api.post( '/contact-forms', data )
  }
});

export default util;
