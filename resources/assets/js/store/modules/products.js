import get from "lodash/get";
import api from "@cbCommerce/api/index";

const initialState = {
	productsList         : [],
	currentProductID     : null,
	activeProduct        : null,
	currentProductReviews: [],
	quotedSKUId 		 : null
};

const getters = {
	productsList      : state => state.productsList,
	productsListArray : state => Vue.options.filters.denormalize( state.productsList ),
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
	updateProductViews: ( {}, id ) => api().post.products.viewed(id),
	saveProduct: (context, product) => new Promise((resolve, reject) => {
		let payload = Object.assign( {}, product );
		let sanitize = ["originalData","skus","media"];
		sanitize.forEach( removal => delete payload[ removal ] );
		if( payload.href ){
			api()
				.put.products.update(payload)
				.then(XHR => {
					context.commit('setActiveProduct', XHR.data);
					resolve(XHR.data);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could update a product with the id of " + id);
				});
		} else {
			api()
				.post.products.create(payload)
				.then(XHR => {
					context.commit("setActiveProduct", XHR.data);
					resolve(XHR.data);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could create product");
				});
		}
	}),
	getSKUWithProduct: ( context, skuId ) => api().get.skus.getWithProduct( skuId ),
	saveSKU: (context, product) => new Promise((resolve, reject) => {
		let payload = Object.assign( {}, product );
		let sanitize = ["originalData","skus","media"];
		sanitize.forEach( removal => delete payload[ removal ] );
		if( payload.href ){
			api()
				.put.skus.update( payload )
				.then(XHR => {
					context.commit('updateSKU', XHR.data);
					resolve(XHR.data);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not save a SKU with an identifier of " + id);
				});
		} else {
			api()
				.post.skus.create( payload )
				.then(XHR => {
					context.commit('updateSKU', XHR.data);
					resolve(XHR.data);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not create a SKU with an identifier of " + id);
				});
		}
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
				commit( 'setProductList', XHR.data );
				resolve( XHR.data );
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
					context.commit( 'setProductList', XHR.data );
					resolve( XHR.data );
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
    } ),
    updateSKUImage : ( context, image ) => new Promise( ( resolve, reject ) => {
        api().put.skus.updateMedia( image )
            .then( XHR => {
                context.commit( "updateSKUImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The SKU image could not be updated");
            } )
    } ),
    updateSKUImageField : ( context, { href, field, value } ) => new Promise( ( resolve, reject ) => {
        api().patch.skus.updateMediaField( href, field, value )
            .then( XHR => {
                context.commit( "updateSKUImage", XHR.data );
                resolve( XHR.data );     
            } )
            .catch( err => {
                console.error(err);
				reject("Error: The SKU image could not be updated");
            } )
    } ),
    createSKUImage: (context, image) => new Promise((resolve, reject) => {
        api().post.skus.createMedia( image )
            .then(XHR => {
                context.commit( "insertSKUImage", XHR.data );
                resolve(XHR.data);
            })
            .catch(err => {
                console.error(err);
                reject("Error: The SKU image could not be updated");
            })
    }),
    deleteSKUImage: ( context, image ) => new Promise( ( resolve, reject ) => {
        api().delete.skus.deleteMedia( image )
            .then(XHR => {
                context.commit( "removeSKUImage", image );
                resolve();
            })
            .catch(err => {
                console.error(err);
                reject("Error: The SKU image could not be deleted");
            })
    } )
};

const mutations = {
	setQuotedSKUId( state , id ){
		Vue.set( state, "quotedSKUId", id );
	},
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
	updateSKUImage(state, mediaItem) {
		let skuIndex = state.activeProduct.skus.findIndex(found => found.id === mediaItem.FK_sku);
		let mediaIndex = state.activeProduct.skus[ skuIndex ].media.findIndex( found => found.id === mediaItem.id );
		state.activeProduct.skus[skuIndex].media.splice( mediaIndex, 1, mediaItem );
	},
	removeSKUImage(state, mediaItem) {
		let skuIndex = state.activeProduct.skus.findIndex(found => found.id === mediaItem.FK_sku);
		let mediaIndex = state.activeProduct.skus[skuIndex].media.findIndex(found => found.id === mediaItem.id);
		if (mediaIndex > -1) {
			state.activeProduct.skus[skuIndex].media.splice(mediaIndex, 1);
		}
	},
	insertSKUImage(state, mediaItem) {
		let skuIndex = state.activeProduct.skus.findIndex(found => found.id === mediaItem.FK_sku);
		state.activeProduct.skus[skuIndex].media.push(mediaItem);
		state.activeProduct.skus[skuIndex].media.sort((a, b) => b.displayOrder - a.displayOrder);
	},
	updateSKU( state, sku ){
		let skuIndex = state.activeProduct.skus.findIndex( found => found.id === sku.id );
		if( skuIndex > -1 ){
			state.activeProduct.skus.splice( skuIndex, 1, sku );
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