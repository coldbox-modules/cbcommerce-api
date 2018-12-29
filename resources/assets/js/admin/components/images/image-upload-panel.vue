<template>

<div class="container mt-2">

		<div class="row">

			<div class="col-md-11 mt-2">
    
			    <h2>{{ sidebarTitle }}</h2>
			    
			</div>

			<div class="col-md-1 mt-2">
				<span class="pull-right">
					<i 
						class="fa fa-close closePanelIcon" 
						@click="closePanel()"></i>
				</span>
			</div>
		    
		    <div class="col-md-12 mt-3">

				<div class="card mb-1">

				    <div class="card-body">

				    	<div class="row">

				    		<div class="col-md-6">

								<vue-dropzone 
									ref="pictureInput" 
									id="image-dropzone" 
									:options="dropzoneOptions"
								></vue-dropzone>

						    </div>


						    <div class="col-md-6">

						    	<div v-if="imageToUpload">

							    	<b-form-group
										label="Title"
										label-for="imageTitle">
										<b-form-input id="imageTitle"></b-form-input>
									</b-form-group>

									<b-form-group
										label="Caption"
										label-for="imageCaption">
										<b-form-textarea
											id="imageCaption"
											:rows="3"
											:max-rows="6">
										</b-form-textarea>
									</b-form-group>

									<b-form-group
										label="Link To"
										label-for="imageHREF">
										<b-form-input id="imageHREF"></b-form-input>
									</b-form-group>

									<b-form-group>

										<b-form-checkbox id="imageIsActive"
											value="true"
											unchecked-value="false">
											Enable the image
										</b-form-checkbox>

									</b-form-group>

									<b-form-group>

										<b-form-checkbox id="imageIsPrimary"
											value="true"
											unchecked-value="false">
											Set as the primary image
										</b-form-checkbox>								

									</b-form-group>

									<button 
										v-if="imageToUpload"
										@click="attemptUpload"
										class="btn btn-success">
										Upload and Save
									</button>

								</div>

						    </div>

					    </div>

					</div>

				</div>

			</div>

		</div>
    
    </div>

</template>
<script>
import FormDataPost from '@cbCommerce/admin/classes/upload';
import vue2Dropzone from 'vue2-dropzone';
import "vue2-dropzone/dist/vue2Dropzone.min.css";
export default {

	components: {
		vueDropzone: vue2Dropzone
	},

	props: {
		sidebarTitle: {
			type   : String,
			default: 'Upload Image'
		}
	},

	data() {
		return {
			imageToUpload: null,
			dropzoneOptions: {
				thumbnailWidth: 150,
				maxFilesize: 0.5
			}
		}
	},

	methods: {

		onPhotoAdded() {
			if( this.$refs.pictureInput.file ){
				this.imageToUpload = this.$refs.pictureInput.file;
			} else {
				console.log( 'Old browser. No support for Filereader API.' );
			}
		},

		onPhotoRemoved() {
			this.imageToUpload = '';
		},

		uploadPhoto() {
			if( this.imageToUpload ){
				console.log( FormDataPost );
				console.log( this.imageToUpload );

				FormDataPost( 'http://localhost:8001/api/picture/upload', this.image )
					.then( response => {
						if( response.data.success ){
							this.imageToUpload = '';
							console.log( 'Image uploaded successfully ✨' );
						}
					} )
					.catch( err => {
						console.error( err );
					} );

			}
		},

		closePanel() {
			this.$emit( 'closePanel', {
				
			} );
		}

	}

}
</script>
<style>
i.closePanelIcon { 
	cursor: pointer;
	font-size: 24px;
}
</style>