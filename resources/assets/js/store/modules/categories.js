import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
    activeCategory : null,
    categories : null,
};

const getters = {
    activeCategoryId : ( state ) => state.activeCategory ? state.activeCategory.id : undefined,
    activeCategory: (state, getters, rootState) => state.activeCategory,
    categoriesListArray : ( state, getters, rootState ) => rootState.filters.denormalize( state.categories ),
    categoriesMap : ( state, getters, rootState ) => state.categories
};
const actions = {
	updateCategoryViews: ( {}, id ) => api().post.categories.viewed(id),
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
        if( categoryData.id && categoryData.id.indexOf('new') === -1 ) {
            api().put.categories.update( categoryData )
                .then(XHR => {
                    context.commit( 'setActiveCategory', XHR.data);
                    resolve( XHR.data );
                })
                .catch(err => {
                    console.error(err);
                    reject("Error: There was an error retreiving the categories");
                });
        } else {
            api().post.categories.save( categoryData )
            .then(XHR => {
                context.commit( 'setActiveCategory', XHR.data);
                resolve( XHR.data );
            })
            .catch(err => {
                reject("Error: There was an error creating the category");
            });
        }
    }),
    updateCategoryImage : ( context, image ) => new Promise( ( resolve, reject ) => {
        api().put.categories.updateMedia( image )
            .then( XHR => {
                context.commit( "updateCategoryImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The category image could not be updated");
            } )
    } ),
    updateCategoryImageField : ( context, { href, field, value } ) => new Promise( ( resolve, reject ) => {
        api().patch.categories.updateMediaField( href, field, value )
            .then( XHR => {
                context.commit( "updateCategoryImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The category image could not be updated");
            } )
    } ),
    createCategoryImage: (context, image) => new Promise((resolve, reject) => {
        api().post.categories.createMedia( image )
            .then(XHR => {
                context.commit( "insertCategoryImage", XHR.data );
                resolve(XHR.data);
            })
            .catch(err => {
                console.error(err);
                reject("Error: The category image could not be updated");
            })
    }),
    deleteCategoryImage: ( context, image ) => new Promise( ( resolve, reject ) => {
        api().delete.categories.deleteMedia( image )
            .then(XHR => {
                context.commit( "removeCategoryImage", image.id );
                resolve();
            })
            .catch(err => {
                console.error(err);
                reject("Error: The category image could not be deleted");
            })
    } )
};
const mutations = {
    clearActiveCategory( state ){
        Vue.set( state, "activeCategory", null );
    },
    setActiveCategory( state, categoryData ) {
        Vue.set( state, "activeCategory", categoryData );
    },
    updateCategoryImage( state, mediaItem ){
        let index = state.activeCategory.media.findIndex( item => item.id === mediaItem.id ); 
        Object.assign(state.activeCategory.media[ index ], mediaItem );
    },
    removeCategoryImage( state, itemId ){
        let index = state.activeCategory.media.findIndex( item => item.id === itemId );
        if( index > -1 ){
            state.activeCategory.media.splice( index, 1 );
        }
    },
    insertCategoryImage( state, mediaItem ){
        state.activeCategory.media.push( mediaItem );
        state.activeCategory.media.sort( ( a, b ) => b.displayOrder - a.displayOrder );
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