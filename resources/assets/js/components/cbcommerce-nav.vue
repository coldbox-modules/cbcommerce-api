<template>
	<div>
		<button type="button" class="navbar-main-toggle" @click="toggleNav()">
	    	<span class="icon-bar"></span>
	    	<span class="icon-bar"></span>
	    	<span class="icon-bar"></span>
	    </button>
		<nav class="navbar navbar-main" role="navigation" :class="{ 'active' : openNav }">
			<div class="navbar-main-header">
				<button type="button" class="navbar-main-close" @click="openNav=false">
			    	<i class="fa fa-times"></i>
			    </button>
		    </div>
		    <div id="navbar-main-collapse">
		        <ul :class="rootMenu.menuClass">
					<template v-if="prependCategories">
						<cbcommerce-nav-item
							v-for="( navItem, index) in categoriesNav"
							:key="`cbcommerce_nav_item_${index}`"
							:navItem="navItem"></cbcommerce-nav-item>
					</template>

		            <cbcommerce-nav-item
		                v-for="(navItem, index) in rootMenu.menuItems"
		                :key="`contentbox_nav_item_${index}`"
		                :navItem="navItem"></cbcommerce-nav-item>


					<template v-if="!prependCategories">
						<cbcommerce-nav-item
							v-for="( navItem, index) in categoriesNav"
							:key="`cbcommerce_nav_item_${index}`"
							:navItem="navItem"></cbcommerce-nav-item>
					</template>
		        </ul>
		    </div>
		</nav>
	</div>
</template>
<script>
import CbcommerceNavItem from './cbcommerce-nav-item';
import { mapState } from 'vuex';
export default {
    props : {
        prependCategories : {
            type : Boolean,
            default : false
        }
    },
    components:{
        CbcommerceNavItem
    },
    data(){
    	return{
    		openNav : false
    	}
    },
    computed: {
        ...mapState({
            rootMenu : state => state.globalData.rootMenu,
            categoriesNav : state => {
                let categories = Vue.options.filters.denormalize( state.globalData.categoriesMap );
                if( ! categories.length ) return [];
                let navBase = {
                    listClass : state.globalData.rootMenu.listClass,
                    itemClass : state.globalData.rootMenu.menuItems[ 0 ].itemClass
                }
                return categories.map( ( cat, index ) => {
                    let catNav = Object.assign( {
                        label : cat.children.length ? cat.name + '<i class="fa fa-caret-right fa-rotate-45"></i>' : cat.name,
                        contentSlug : `store/category/${cat.id}`,
                        children : [],
                        urlClass : cat.children.length ? 'dropdown-toggle' : state.globalData.rootMenu.menuItems[ 0 ].urlClass
                    }, navBase );
                    if( cat.children && cat.children.length ){
                        cat.children.forEach(
                            subCat => {

                                let subCatNav = Object.assign( {
                                    label : subCat.name,
                                    contentSlug : `store/category/${subCat.id}`,
                                    children : [],
                                    urlClass : ''
                                }, navBase );

                                if( subCat.children ){
                                    subCat.children.forEach(
                                        subSubCat => {

                                            let subSubCatNav = Object.assign( {
                                                label : subSubCat.name,
                                                contentSlug : `store/category/${subSubCat.id}`,
                                                urlClass : ''
                                            }, navBase );

                                            subCatNav.children.push( subSubCatNav );

                                        }
                                    );
                                }

                                catNav.children.push( subCatNav )

                            }
                        );
                    }
                    return catNav;
                } )
            }
        }),
    },
    methods: {
    	toggleNav(){
    		this.openNav = !this.openNav;
    	}
    }
}
</script>