<template>

    <a
        v-on:mouseover="mouseover"
        href="javascript:;"
        :data-image="mainImage"
        :data-zoom-image="zoomImage">
        <img
            :src="thumbImage" />
    </a>

</template>


<script>
import "ez-plus/src/jquery.ez-plus.js";
export default {

    props: [
        'galleryItem',
        'totalThumbs'
    ],

    data() {
        return {
            mainImage : null,
            zoomImage : null,
            thumbImage: null
        }
    },

    created: function(){
        this.parseContent();
        this.$emit( 'thumbLoaded' );
    },

    mounted() {
    },

    destroyed() {},

    methods: {

        mouseover: function(){

            var smallImage = this.$el.getAttribute( 'data-image' );
            var largeImage = this.$el.getAttribute( 'data-zoom-image' );
            var ez         = $( '#product-zoom' ).data( 'ezPlus' );
            ez.swaptheimage( smallImage, largeImage );

        },

        parseContent: function(){
            var self          = this;
            var parsedContent = self.galleryItem;
            self.mainImage    = parsedContent.href;
            self.zoomImage    = parsedContent.href;
            self.thumbImage   = parsedContent.href;
        }

    }

}
</script>