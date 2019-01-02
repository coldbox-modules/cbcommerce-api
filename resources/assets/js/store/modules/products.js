import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	productsList         : [],
	currentProductID     : null,
	activeProduct        : null,
	currentProductReviews: []
};

const getters = {
	productsList      : state => state.productsList,
	productsListArray : state => Object.values(state.productsList),
	currentProductID  : state => state.currentProductID,
	currentProduct    : state => 
		state.activeProduct || get(state, ["productsList", state.currentProductID], null),
	currentProductName: state => {
		const n = get(
			state,
			["productsList", state.currentProductID, "productName"],
			null
		);
		return n;
	},
	currentProductReviews : state => state.currentProductReviews
};

const actions = {
	saveProduct: (context, product) => new Promise((resolve, reject) => {
		let payload = Object.assign( {}, product );
		let sanitize = ["originalData","skus","media"];
		sanitize.forEach( removal => delete payload[ removal ] );
		api()
			.put.products.update( payload )
			.then(XHR => {
				commit('setActiveProduct', XHR.data);
				resolve(XHR.data);
			})
			.catch(err => {
				console.error(err);
				reject("Error: Could retrieve a product with the id of " + id);
			});
	}),
	saveSKU: (context, product) => new Promise((resolve, reject) => {
		let payload = Object.assign( {}, product );
		let sanitize = ["originalData","skus","media"];
		sanitize.forEach( removal => delete payload[ removal ] );
		api()
			.put.skus.update( payload )
			.then(XHR => {
				commit('updateSKU', XHR.data);
				resolve(XHR.data);
			})
			.catch(err => {
				console.error(err);
				reject("Error: Could retrieve a product with the id of " + id);
			});
	}),
	getProduct: ( { commit }, id ) => {
		if( id.id ){
			var params = id;
			id = params.id;
			delete params.id;
		} else {
			params = undefined;
		}
		commit( "setCurrentProduct", id );
		return new Promise( (resolve, reject) => {
			api()
				.get.products.detail( id, params )
				.then( XHR => {
					commit('setActiveProduct', XHR.data);
					resolve( XHR.data );
				} )
				.catch( err => {
					console.error(err);
					reject("Error: Could retrieve a product with the id of " + id );
				} );
		} );
	},
	getCategoryProducts: ({ commit, rootState }, categoryId ) => new Promise( (resolve, reject) => {
		api()
			.get.products.list( { category : categoryId } )
			.then(XHR => {
				const products = rootState.filters.denormalize( XHR.data );
				// Normalize
				const normProducts = {};
				products.forEach(p => {
					normProducts[ p.id ] = p;
				});
				commit( 'setProductList', normProducts );
				resolve( normProducts );
			})
			.catch(err => {
				console.error(err);
				reject("Error: Could not resolve list of products");
			});
	}),
	getListOfProducts: ( context, params ) =>
		new Promise((resolve, reject) => {
			api()
				.get.products.list( params )
				.then( XHR => {
					let list = XHR.data;
					const products = context.rootState.filters.denormalize( list );
					if(!products || products.length === 0){
						throw new Error("No products found");
					}
					// Normalize
					const normProducts = {};
					products.forEach(p => {
						normProducts[p.id] = p;
					});
					context.commit( 'setProductList', normProducts );
					resolve(normProducts);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of products");
				});
		}),
	getProductReviews: ( context, productId ) =>
		new Promise((resolve, reject) => {
			api()
				.get.reviews.list( productId )
				.then(XHR => {
					let list = XHR.data;
					const reviews = context.rootState.filters.denormalize( list );
					if (!reviews || reviews.length === 0) {
						throw new Error("No reviews found");
					}
					context.commit( "setCurrentProductReviews", reviews);
					resolve(reviews);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of reviews");
				});
		}),
	setCurrentProduct: ({ commit }, productID) => {
		commit( 'setCurrentProduct', productID );
	},
	clearCurrentProduct: ({ commit }) => {
		commit( 'clearCurrentProduct' );
	},
    updateProductImage : ( context, image ) => new Promise( ( resolve, reject ) => {
        api().put.products.updateMedia( image )
            .then( XHR => {
                context.commit( "updateProductImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The category image could not be updated");
            } )
    } ),
    updateProductImageField : ( context, { href, field, value } ) => new Promise( ( resolve, reject ) => {
        api().patch.products.updateMediaField( href, field, value )
            .then( XHR => {
                context.commit( "updateProductImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The category image could not be updated");
            } )
    } ),
    createProductImage: (context, image) => new Promise((resolve, reject) => {
        api().post.products.createMedia( image )
            .then(XHR => {
                context.commit( "insertProductImage", XHR.data );
                resolve(XHR.data);
            })
            .catch(err => {
                console.error(err);
                reject("Error: The category image could not be updated");
            })
    }),
    deleteProductImage: ( context, image ) => new Promise( ( resolve, reject ) => {
        api().delete.products.deleteMedia( image )
            .then(XHR => {
                context.commit( "removeProductImage", image.id );
                resolve();
            })
            .catch(err => {
                console.error(err);
                reject("Error: The category image could not be deleted");
            })
    } )
};

const mutations = {
	setActiveProduct(state, product) {
		state.currentProductID = product.id;
		Vue.set( state, "activeProduct", product );
	},
	setProductList(state, list) {
		state.productsList = list;
	},
	setCurrentProduct(state, productID) {
		state.currentProductID = productID;
	},
	clearCurrentProduct(state) {
		state.currentProductID = null;
	},
	setCurrentProductReviews(state, list) {
		state.currentProductReviews = list;
	},
	updateProductImage(state, mediaItem) {
		let index = state.activeProduct.media.findIndex(item => item.id === mediaItem.id);
		Object.assign(state.activeProduct.media[index], mediaItem);
	},
	removeProductImage(state, itemId) {
		let index = state.activeProduct.media.findIndex(item => item.id === itemId);
		if (index > -1) {
			state.activeProduct.media.splice(index, 1);
		}
	},
	insertProductImage(state, mediaItem) {
		state.activeProduct.media.push(mediaItem);
		state.activeProduct.media.sort((a, b) => b.displayOrder - a.displayOrder);
	},
	updateSku( state, sku ){
		let skuIndex = state.activeProduct.skus.findIndex( found => found.id === sku.id );
		if( skuIndex > -1 ){
			state.activeProduct.skus.slice( skuIndex, 1, sku );
		} else {
			state.activeProduct.skus.push( sku );
		}
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}