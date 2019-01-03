<template>
    <div class="category-detail">

        <div class="col-md-12 productDetailHeader" v-if="activeCategory">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">{{activeCategory.name}}</h1>
            <p v-html="activeCategory.description"></p>
        </div>
        <div class="col-xs-12 category-products" v-if="!isLoading">
            <div 
                class="col-md-3 col-sm-2"
                v-for="(product, index) in this.productsListArray"
                :key="index"
            >
                <product-item :product="product"></product-item>
            </div>
        </div>
        <div class="col-xs-12 category-products" v-else>
            <div class="col-md-3" v-for="(n, index) in 4" :key="`loading-${index}`">
                <product-item-loading></product-item-loading>
            </div>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import SubCategoryLinks from "@cbCommerce/components/categories/sub-category-links";
import CategoryGridItem from "@cbCommerce/components/categories/category-grid-item";
import CategoryGridItemLoading from "@cbCommerce/components/categories/category-grid-item-loading";
import ProductItem from '@cbCommerce/components/products/product-item';
import ProductItemLoading from '@cbCommerce/components/products/product-item-loading';

export default{
    data(){
        return {
            isLoading : false
        };
    },
    components: {
        SubCategoryLinks,
        CategoryGridItem,
        CategoryGridItemLoading,
        ProductItem,
        ProductItemLoading
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
            "getCategoryProducts"
        ]),
        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }
    },
    created(){
        var self = this;
        Vue.set( self, "isLoading", true );
        this.getCategory( self.categoryId ).then( category => self.getCategoryProducts( category.id ).then( products => { Vue.set( self, "isLoading", false ) } ) )
    }

}
</script>