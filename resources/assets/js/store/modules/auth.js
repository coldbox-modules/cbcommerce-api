import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {};

const getters = {
    authUser: ( state, getters, rootState ) => rootState.globalData.cbcAuthUser || null
};
const actions = {
    authenticate: ( context, { email, password } ) => {
        return new Promise( (resolve, reject) => {
            api().post.authentication.login( { email, password } )
						.then( XHR => {
							context.commit( 'setAuthUser', { rootState: context.rootState, authUser : XHR.data } );
							resolve( XHR.data );
						} )
						.catch( err => {
                            console.error(err);
							reject( "Error: The user could not be authenticated" );
						});
		} );
    },
    logout: ( context ) => {
    	new Promise( (resolve, reject) => {
	        api().delete.authentication.logout()
                .then( XHR => {
                    context.commit( 'setAuthUser', { rootState: context.rootState, authUser : null } );
                    window.location.reload();
                    resolve( XHR.data );
                } )
                .catch( err => {
                    console.error( err );
					reject( "Error: An error occurred when attempting to log out the user" );
                } )
	    } );
    }
};
const mutations = {
    setAuthUser( state, { rootState, authUser } ) {
        Vue.set(rootState.globalData, "cbcAuthUser", authUser );
    }
};

export default {
    state: initialState,
    getters,
    actions,
    mutations
}