import get from "lodash/get";
import api from "../../api/index";

function keyForCategory( { id } ){
	return `categoriesList_${id}`;
}

const initialState = {
	categoriesList         : [],
	currentCategoryID     : null,
};

const getters = {
	categoriesList     : state => state.categoriesList,
	categoriesListArray: state => Object.values(state.categoriesList),
	currentCategoryID : state => state.currentCategoryID,
	currentCategory   : state => 
		get(state, ["categoriesList", state.currentCategoryID], null),
	currentCategoryName: state => {
		const n = get(
			state,
			["categoriesList", state.currentCategoryID, "name"],
			null
		);
		return n;
	},
};

const actions = {
	getListOfCategories: ({ commit }) =>
		new Promise((resolve, reject) => {
			api()
				.get.categories.list()
				.then(list => {
					const categories = list;
					if(!categories || categories.length === 0){
						throw new Error("No categories found");
					}
					// Normalize
					const normCategories = {};
					categories.forEach(p => {
						normCategories[p.id] = p;
					});
					commit( 'setCategoriesList', normCategories );
					resolve(normCategories);
				})
				.catch(err => {
					console.error(err);
					reject("Error: Could not resolve list of categories");
				});
		}),
	setCurrentCategory: ({ commit }, categoryID) => {
		commit( 'setCurrentCategory', categoryID );
	},
	clearCurrentCategory: ({ commit }) => {
		commit( 'clearCurrentCategory' );
	}
};

const mutations = {
	setCategoriesList( state, list ){
		state.categoriesList = list;
	},
	setCurrentCategory( state, categoryID ){
		state.currentCategoryID = categoryID;
	},
	clearCurrentCategory( state ){
		state.currentCategoryID = null;
	}
};

export default {
	state: initialState,
	getters,
	actions,
	mutations
}