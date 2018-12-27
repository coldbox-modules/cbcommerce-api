<template>
    <div class="category-detail">

        <div class="col-md-12 productDetailHeader" v-if="activeCategory">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">{{activeCategory.name}}</h1>
            <p v-html="activeCategory.description"></p>
        </div>
        <div class="col-xs-12 category-products" v-if="activeCategory">
            <div>
                <product-carousel
                    carouselId="owl-carousel-category-products"
                ></product-carousel>
            </div>
        </div>

    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import SubCategoryLinks from "@cbCommerce/components/categories/sub-category-links";
import CategoryGridItem from "@cbCommerce/components/categories/category-grid-item";
import CategoryGridItemLoading from "@cbCommerce/components/categories/category-grid-item-loading";
import ProductCarousel from "@cbCommerce/components/products/product-carousel";

export default{
    actions: {

    },
    components: {
        SubCategoryLinks,
        CategoryGridItem,
        CategoryGridItemLoading,
        ProductCarousel
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
        this.getCategory( self.categoryId ).then( category => self.getCategoryProducts( category.id ) )
    }

}
</script>