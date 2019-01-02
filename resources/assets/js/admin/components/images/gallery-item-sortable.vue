<template>
  <div 
    class="imageGridItem"
    v-bind:class="{ primaryImage: image.isPrimary }"
    :style="`background: url(${image.src});background-size:cover;height:150px;width:150px`">
        <div 
          v-if="withButton"
          @click="showImageDetailPanel">
            <i class="icon-edit-btn fa fa-edit"></i>
        </div>
        <div 
          v-if="withButton"
          @click="deleteItem">
            <i class="icon-delete-btn fa fa-trash"></i>
        </div>
    <slot>
    </slot>
  </div>
</template>

<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import imageSidebar from './image-sidebar';
export default {

  components: {
    imageSidebar
  },

  props: {
    index: {
      type: Number
    },
    withButton: {
      type: Boolean,
      default: false
    },
    image: {
      type: Object,
      required: true
    },
    eventPrefix : {
      type : String,
      default : ""
    }
  },

  methods: {
    deleteItem() {
      Event.$emit( this.eventPrefix + 'deleteMediaItem', this.image );
    },
    showImageDetailPanel() {
      var thisImage = this.image;
      vueSlideoutPanelService.show( {
        component: imageSidebar,
        width    : '1020px',
        cssClass : 'slideout-panel-overall',
        props    : {
            eventPrefix : this.eventPrefix,
            data: {
              image: thisImage
            }
        }
      } );
    }

  }

}
</script>

<style>
.imageGridItem {
  position: relative;
  background-color: #fff;
  margin: 14px;
  height: 200px;
  width: 200px;
  border-radius: 10px;
  box-shadow: 0px 6px 20px rgba(0, 0, 0, 0.07);
  color: #777;
  font-weight: 900;
  font-size: 12px;
  line-height: 200px;
  text-align: center;
  transition: all 0.3s;
  cursor: pointer;
}

.primaryImage {
  border: 1px solid green;
}

.imageGridItem img {
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -o-user-select: none;
  user-select: none;
}

.imageGridItem .icon-edit-btn {
  display: block;
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 7px;
  left: 6px;
  top: 6px;
  border: 1px solid rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.2);
}

.imageGridItem .icon-delete-btn {
  display: block;
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 7px;
  right: 8px;
  top: 6px;
  border: 1px solid rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.2);
  cursor: pointer;
}
</style>