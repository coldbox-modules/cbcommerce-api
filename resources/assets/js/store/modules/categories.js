import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
    activeCategory : null
};

const getters = {
    activeCategory: (state, getters, rootState) => state.activeCategory
};
const actions = {
    getCategory: (context, id ) => {
        return new Promise((resolve, reject) => {
            api().get.categories.get( id )
                .then(XHR => {
                    context.commit( 'setActiveCategory', XHR.data );
                    resolve( XHR.data );
                })
                .catch(err => {
                    console.error( err );
                    reject("Error: There was an error retreiving the categories");
                });
        });
    }
};
const mutations = {
    setActiveCategory( state, categoryData ) {
        Vue.set( state, "activeCategory", categoryData );
    }
};

export default {
    state: initialState,
    getters,
    actions,
    mutations
}