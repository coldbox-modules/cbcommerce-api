<template>
    <div class="category-detail">

        <div class="col-md-12 productDetailHeader" v-if="activeCategory">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">{{activeCategory.name}}</h1>
            <p v-html="activeCategory.description"></p>
        </div>
        <div class="col-xs-12 category-products" v-if="!isLoading">
            <product-filter-page :initialParams="{category:categoryId}"></product-filter-page>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import SubCategoryLinks from "@cbCommerce/components/categories/sub-category-links";
import ProductItemLoading from '@cbCommerce/components/products/product-item-loading';
import ProductFilterPage from '@cbCommerce/components/products/product-filter-page';

export default{
    data(){
        return {
            isLoading : false
        };
    },
    components: {
        SubCategoryLinks,
        ProductItemLoading,
        ProductFilterPage
    },
    computed : {
        ...mapGetters( [
            "activeCategory",
            "productsListArray"
        ] ),
        categoryId : () => {
            var locationParts = window.location.pathname.split( '/' );
            return locationParts[ locationParts.length - 1 ]; 
        }
    },
    methods : {
        ...mapActions([
            "getCategory",
            "getCategoryProducts",
            "updateCategoryViews"
        ]),
        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }
    },
    created(){
        var self = this;
        Vue.set( self, "isLoading", true );
        this.getCategory( self.categoryId ).then( category => {
            self.updateCategoryViews( self.categoryId );
            Vue.set( self, "isLoading", false );
        } );
    }

}
</script>