<template>
    
    <div class="product-images-gallery" v-if="media.length">

        <div 
            v-images-loaded:on.progress="imageProgress"
            class="product-image zoomWrapper">
            
            <img 
                id="product-zoom" 
                :src="media[ 0 ].src" 
                :data-zoom-image="media[ 0 ].src" 
                :alt="media[ 0 ].caption" />

        </div>

        <div id="thumbnailNestedGallery" v-if="media.length > 1">

            <product-gallery-thumb
                v-for="(mediaItem, index) in media"
                :key="index"
                :galleryItem="mediaItem"
                :totalThumbs="media.length"
                v-on:thumbLoaded="thumbLoadedResponse"
            ></product-gallery-thumb>

        </div>

    </div>

</template>
<script>
import ProductGalleryThumb from './product-gallery-thumb';
import imagesLoaded from 'vue-images-loaded';
import "ez-plus/src/jquery.ez-plus.js";
export default{
    components: {
        ProductGalleryThumb
    },
    directives: {
        imagesLoaded
    },
    props : {
        media : {
            type : Array,
            required : true
        }
    },
    mounted(){
        $( '#product-zoom' ).ezPlus(
            {
                gallery: 'thumbnailNestedGallery', 
                cursor: 'crosshair', 
                galleryActiveClass: 'active',
                imageCrossfade: true
            }
        );
    },
    methods: {
        thumbLoadedResponse: function(){
            if( !this.productGallery ) return;
            this.thumbLoadCount++;
             
        },

        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }
    }
}

</script>