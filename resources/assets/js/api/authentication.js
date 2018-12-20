export const getAuth = api => () => api.get( '/authentication' );
export const authenticate = api => ( payload ) => api.post( '/authentication', JSON.stringify( payload ) );
export const logout = api => ( itemId ) => api.delete( '/authentication' );

export const authentication = api => ({
  get: {
    authentication: {
    	get: getAuth( api )
    }
  },
  post: {
    authentication: {
      login: authenticate( api )
    }
  },
  delete: {
    authentication: {
      logout: logout( api )
    }
  }
});

export default authentication;
