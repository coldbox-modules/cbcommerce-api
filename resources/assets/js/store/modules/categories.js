import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
    activeCategory : null,
    categories : null,
};

const getters = {
    activeCategory: (state, getters, rootState) => state.activeCategory,
    categoriesListArray : ( state, getters, rootState ) => rootState.filters.denormalize( state.categories ),
    categoriesMap : ( state, getters, rootState ) => state.categories
};
const actions = {
    getCategories: ({ commit, rootState }, params) => new Promise( ( resolve, reject ) => {
        api().get.categories.list( params )
            .then(XHR => {
                commit( 'setCategories', XHR.data );
                resolve(XHR.data);
            })
            .catch(err => {
                console.error(err);
                reject("Error: There was an error retreiving the categories");
            });
    }),
    getCategory: (context, request ) => {
        if( typeof( request ) == "object" ){
            var id = request.id;
            var params = request.params;
        } else {
            var id = request;
            var params = undefined;
        }
        return new Promise((resolve, reject) => {
            api().get.categories.get( id, params )
                .then(XHR => {
                    context.commit( 'setActiveCategory', XHR.data );
                    resolve( XHR.data );
                })
                .catch(err => {
                    console.error( err );
                    reject("Error: There was an error retreiving the categories");
                });
        });
    },
    saveCategory: (context, categoryData) => new Promise( (resolve, reject) => {
        api().put.categories.update( categoryData )
            .then(XHR => {
                context.commit( 'setActiveCategory', XHR.data);
                resolve( XHR.data );
            })
            .catch(err => {
                console.error(err);
                reject("Error: There was an error retreiving the categories");
            });
    })
};
const mutations = {
    setActiveCategory( state, categoryData ) {
        Vue.set( state, "activeCategory", categoryData );
    },
    setCategories( state, resultsMap ){
        Vue.set( state, "categories", resultsMap );
    }
};

export default {
    state: initialState,
    getters,
    actions,
    mutations
}