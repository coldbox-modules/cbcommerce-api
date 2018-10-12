<template>
  <b-card
    :bg-variant="detectPrimaryStatus">
    <div class="card-image">
      <img 
        :src="image.variations.thumbnail" 
        class="img-responsive selectable-image" height="200" width="200" 
        @click="showImageDetailPanel" />

    </div>
  </b-card>
</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import imageSidebar from './image-sidebar';
export default {

  props: ['image'],

  components: {
    imageSidebar
  },

  computed: {

    detectPrimaryStatus() {
      return ( this.image.isPrimary ) ? 'success' : '';
    }

  },

  methods: {

    showImageDetailPanel() {

      vueSlideoutPanelService.show( {
        component: imageSidebar,
        width    : '1020px',
        cssClass : 'slideout-panel-overall',
        props    : {
          data: {
            image: this.image
          },
        }
      } );

    }

  }

}
</script>
<style>
img.selectable-image { cursor: pointer; }
</style>