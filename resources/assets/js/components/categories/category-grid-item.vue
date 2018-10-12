<template>

    <div class="col-xs-12 col-sm-6 col-md-4 text-center mb-25">

        <article class="category light">

            <div v-if="!isLoading">

                <div v-bind:class="{ loading: isLoading }" >
                    <div class="spinner" v-if="isLoading">
                        <i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
                        <span class="sr-only">Removing...</span>
                    </div>
                </div>

                <figure class="figure-hover-overlay">

                    <img 
                        v-images-loaded:on.progress="imageProgress"
                        :src="this.image" 
                        :alt="this.catName"
                        class="img-responsive" />

                </figure>

                <div class="category-caption">
                    <div class="block-name">
                        <a :href="this.catLink" class="category-name">{{ this.catName }}</a>

                    </div>
                </div>

                <p class="description">
                    {{ this.description }}
                </p>

                <sub-category-links 
                    v-for="(subCat, index) in this.subCats"
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
        this.isLoading = true;
        this.parseContent();
    },

    data() {
        return {
            isLoading  : true,
            catName    : null,
            catLink    : null,
            description: null,
            image      : null,
            subCats    : null
        }
    },

    mounted() {},

    destroyed() {},

    methods: {
        parseContent: function(){
            var self          = this;
            var parsedContent = self.category;
            self.catName      = parsedContent.categoryName;
            self.catLink      = parsedContent.link;
            self.description  = parsedContent.description;
            self.image        = parsedContent.image;
            self.subCats      = parsedContent.subCats;
            self.isLoading    = false;
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