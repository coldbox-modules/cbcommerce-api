
<template>

	<div class="imageGridHolder">

		<grid
			:center="false"
			:draggable="true"
			:sortable="true"
			:items="images"
			:cellHeight="200"
			:cellWidth="200"
			:height="200"
			:width="200"
			@sort="sort">
	      <template slot="cell" slot-scope="props">
	        <gallery-item-sortable 
	        	:image="props.item"
            :index="props.index"
            :with-button="true" />
	      </template>
	    </grid>

			<div v-if="!readOnly">
				<vue-dropzone
					v-on:vdropzone-sending="onSendFile"
					v-on:vdropzone-success="onFileUploaded"
					v-on:vdropzone-queue-complete="onUploadQueueComplete"
					ref="galleryDropzone" 
					id="dropzone" 
					:options="dropzoneOptions"
					:useCustomSlot="true"
				>
					<div class="dropzone-custom-content">
						<h4 class="dropzone-custom-title">Drag images here to upload</h4>
						<div class="subtitle">...or click to select a file from your computer</div>
						<p class="text-center"><i class="fa fa-cloud-upload fa-3x"></i></p>
					</div>
				</vue-dropzone>
			</div>

	</div>

</template>
<script>
import { mapActions } from "vuex";
import GalleryItemSortable from './gallery-item-sortable.vue';
import vue2Dropzone from 'vue2-dropzone';
export default {
	props : {
		images : {
			type : Array
		},
		readOnly : {
			type : Boolean,
			default : false
		},
		endpoint : {
			type : String,
			default : null
		}
	},
	components: {
		vueDropzone: vue2Dropzone,
		GalleryItemSortable
	},
	data() {
	    return {
				dropzoneOptions: {
					url: this.endpoint,
					thumbnailWidth: 150,
					maxFilesize: 100
				}
			};
	},

	methods: {
	    sort( event ){
				console.log( 'sort', event );
				Event.$emit( "onMediaSort", event );
			},
			onSendFile( file, XHR, formData ){
				Object.assign( formData, self.form );
			},
			onFileUploaded( file, response ){
				Event.$emit( "mediaUploadSuccess", response );
				this.$refs.galleryDropzone.removeFile( file );
			},
			onUploadQueueComplete(){
				this.$emit( "closePanel" );
			}

 	}

}
</script>