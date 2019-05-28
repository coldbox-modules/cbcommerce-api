<template>

<div class="container mt-2 sidebar-panel">

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
									v-if="false"
									v-on:vdropzone-sending="onSendFile"
									v-on:vdropzone-success="onFileUploaded"
									v-on:vdropzone-queue-complete="onUploadQueueComplete"
									ref="pictureInput" 
									id="dropzone" 
									:options="dropzoneOptions"
								></vue-dropzone>

						    </div>


						    <div class="col-md-6" v-if="imageToUpload">
									
								<b-form-group
									label="Caption"
									label-for="imageCaption">
									<b-form-textarea
										v-model="form.caption"
										id="imageCaption"
										:rows="3"
										:max-rows="6">
									</b-form-textarea>
								</b-form-group>

                <b-form-group label="Enable the image">
                     <b-form-radio-group
                     v-model="form.isActive"
                     :options="booleanOptions"
                     name="isActive"
                     ></b-form-radio-group>
                 </b-form-group>

								<b-form-group>

                <b-form-group label="Set as the primary image">
                			<b-form-radio-group
                			v-model="form.isPrimary"
                			:options="booleanOptions"
                      name="isPrimary"
                      ></b-form-radio-group>
                </b-form-group>							

								</b-form-group>

								<button 
									v-if="imageToUpload"
									@click="attemptUpload"
									class="btn btn-success">
									Upload and Save
								</button>

						    </div>
							<div class="col-md-6" v-else></div>

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
import { Form } from '@cbCommerce/admin/classes/form';
export default {

	components: {
		vueDropzone: vue2Dropzone
	},

	props: {
		endpoint : {
			type : String,
			required : true
		},
		sidebarTitle: {
			type   : String,
			default: 'Upload Image'
		}
	},

	data() {
		return {
			form : new Form( { isActive: true, isPrimary: false, caption: "" } ),
			imageToUpload: null,
			dropzoneOptions: {
				url: this.endpoint,
				thumbnailWidth: 150,
				maxFilesize: 100,
        booleanOptions : [
            { text: 'Yes', value: true },
            { text: 'No', value: false }
        ]
			}
		}
	},
	methods: {
		onSendFile( file, XHR, formData ){
			Object.assign( formData, self.form );
		},
		onFileUploaded( file, response ){
			Event.$emit( "mediaUploadSuccess", response );
		},
		onUploadQueueComplete(){
			this.$emit( "closePanel" );
		}

	}

}
</script>
<style scoped>
i.closePanelIcon { 
	cursor: pointer;
	font-size: 24px;
}
</style>