<template>

    <div class="col-xs-12 col-sm-6 col-md-4 text-center mb-25">

        <article class="category light">

            <div v-if="!isLoading">

                <div v-bind:class="{ loading: isLoading }" >
                    <div class="spinner" v-if="isLoading">
                        <i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
                        <span class="sr-only">Loading product category...</span>
                    </div>
                </div>

                <figure class="figure-hover-overlay">

                    <img 
                        v-images-loaded:on.progress="imageProgress"
                        :src="primaryImage()" 
                        :alt="category.name"
                        class="img-responsive" />

                </figure>

                <div class="category-caption">
                    <div class="block-name">
                        <a :href="`/store/category/${category.id}`" class="category-name">{{ category.name }}</a>

                    </div>
                </div>
                <p class="tag_number">
                        {{product.externalId}}
                </p>

                <sub-category-links 
                    v-for="(subCat, index) in category.children"
                    :key="index"
                    :subCat="subCat"></sub-category-links>

            </div>

            <div v-if="isLoading">
                <category-grid-item-loading></category-grid-item-loading>
            </div>

        </article>

    </div>

</template>

<script>
import imagesLoaded from 'vue-images-loaded';
import CategoryGridItemLoading from './category-grid-item-loading';
import SubCategoryLinks from './sub-category-links';
export default {
    components: {
        CategoryGridItemLoading,
        SubCategoryLinks
    },
    directives: {
        imagesLoaded
    },
    props: [
        'category'
    ],

    created: function(){
        this.isLoading = false;
    },

    data() {
        return {
            isLoading  : true
        }
    },

    mounted() {},

    destroyed() {},

    methods: {
        primaryImage: function(){
            return this.category.media.length ? this.category.media[ 0 ] : '';
        },
        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }
    },

    computed: {}
}
</script>

<style>
    
</style>