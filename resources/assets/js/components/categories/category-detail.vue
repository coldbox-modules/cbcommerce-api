<template>
    <div class="category-detail">

        <div class="col-md-12 productDetailHeader" v-if="activeCategory">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">{{activeCategory.name}}</h1>
        </div>
        <div class="col-md-12" v-if="activeCategory">

            <div class="block-product-detail">

                <div class="row">

                    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">

                        <div 
                            v-images-loaded:on.progress="imageProgress"
                            class="product-image">

                            
                            <img 
                                v-if="activeCategory.media.length"
                                id="product-zoom" 
                                :src="activeCategory.media[ 0 ].href" 
                                :data-zoom-image="activeCategory.media[ 0 ].href" 
                                :alt="activeCategory.media[ 0 ].caption" />

                            <div id="thumbnailNestedGallery">

                                <product-gallery-thumb
                                    v-for="(mediaItem, index) in activeCategory.media"
                                    :key="index"
                                    :galleryItem="mediaItem"
                                    :totalThumbs="activeCategory.media.length"
                                    v-on:thumbLoaded="thumbLoadedResponse"
                                ></product-gallery-thumb>

                            </div>

                        </div>

                    </div>

                    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                        <div class="product-detail-section">
                            <p v-html="activeCategory.description"></p>
                        </div>
                    </div>

                    <div class="clearfix"></div>

                    <div class="col-xs-12 category-products">
                        <h2>Products</h2>
                        <div v-if="productsList.length">
                            <product-carousel
                                carouselId="owl-carousel-category-products"
                            ></product-carousel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import SubCategoryLinks from "@cbCommerce/components/categories/sub-category-links";
import CategoryGridItem from "@cbCommerce/components/categories/category-grid-item";
import CategoryGridItemLoading from "@cbCommerce/components/categories/category-grid-item-loading";

export default{
    actions: {

    },
    components: {
        CategoryGridItem,
        CategoryGridItemLoading
    },
    computed : {
        ...mapGetters( [
            "activeCategory",
            "productsList"
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