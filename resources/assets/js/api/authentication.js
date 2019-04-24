export const getAuth = api => () => api.get( '/authentication' );
export const authenticate = api => ( payload ) => api.post( '/authentication', JSON.stringify( payload ) );
export const logout = api => ( itemId ) => api.delete( '/authentication' );
export const resetPassword = api => ( email ) => api.post( '/authentication/password-reset', JSON.stringify( { email : email } ) );

export const authentication = api => ({
  get: {
    authentication: {
    	get: getAuth( api )
    }
  },
  post: {
    authentication: {
      login: authenticate( api ),
      resetPassword : resetPassword( api )
    }
  },
  delete: {
    authentication: {
      logout: logout( api )
    }
  }
});

export default authentication;
