<template>

	<div>

		<div v-if="!this.isLoading">

	        <page-header :headerTitle="`Category: ${ form.categoryName }`"></page-header>

			<dismissable-alert v-if="isSent && !isSending"
				alertText="The item has been updated."
				alertType="success">
			</dismissable-alert>

			<form @submit.prevent="handleSubmit">
			    
			    <b-row>

			        <b-col cols="12">

			            <b-form-group
							label="Category Name"
							label-for="categoryName">
							<b-form-input 
		                    	required="required"
		                    	class="form-control" 
		                    	id="categoryName"
		                    	v-model="form.categoryName" />
						</b-form-group>

			        </b-col>

			    </b-row>

			    <b-row>

			        <b-col cols="12">

			            <b-form-group
							label="Category Description"
							label-for="description">
		                    <html-editor 
			            		height="200" 
			            		:model.sync="form.description"></html-editor>
						</b-form-group>

			        </b-col>

			    </b-row>

			    <b-row>

			    	<b-col cols="12">

				    	<b-card no-body class="mb-1">

				    		<b-card-header header-tags="header" class="p-1" role="tab">
				    			<b-btn block href="#" v-b-toggle.images>Images</b-btn>
				    		</b-card-header>
				    		<b-collapse id="images" accordion="product-accordion" role="tabpanel">
				    			<b-card-body>

				    				<b-col cols="12" class="mb-5">
				    					<span 
				    						class="pull-right">
				    						<a 
				    							class="btn btn-success uploadNewImageBtn"			    				
				    							@click="showImageUploadPanel()">
				    							<i class="fa fa-upload"></i>
				    						</a>
				    					</span>
				    				</b-col>

									<gallery-list-sortable 
										:images="categoryImages"></gallery-list-sortable>

				    			</b-card-body>
				    		</b-collapse>

				    	</b-card>

					</b-col>

				</b-row>


			    <b-row>
			        
			        <b-col cols="12">

			             <b-form-group>

						    <b-form-checkbox 
						    	v-model="form.active" 
						    	:model.sync="form.active">
						    	Enable Category
						    </b-form-checkbox>

						</b-form-group>

			        </b-col>

			    </b-row>

			    <button type="submit" class="btn btn-secondary btn-lg">Save</button>

			    <back-button link="/categories" text="Back to categories"></back-button>
			    
			</form>

		</div>

	</div>

</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
import VueImgLoader from 'vue-img-loader';
import { Form } from '@/admin/classes/form';
import htmlEditor from '@/components/admin/ui/html-editor';
import galleryList from '@/components/admin/images/gallery-list';
import galleryListSortable from '@/components/admin/images/gallery-list-sortable';
import imageUploadPanel from '@/components/admin/images/image-upload-panel';
export default {
	name: "CategoryForm",

	components: {
		htmlEditor,
		VueImgLoader,
		galleryList,
		galleryListSortable,
		imageUploadPanel,
	},

    data() {
        return {
			isLoading     : false,
			form          : new Form(),
			url           : '', /* The URL to post the submission to */
			moment        : moment,
			categoryImage : null,
			errors        : [],
			isSending     : false,
			isSent        : false,
			categoryImages: []
        }
    },

	computed: {
		...mapGetters([
			"currentCategory",
			"currentCategoryID",
			"categoriesList"
		])
	},

	created() {
		if( !this.currentCategoryID ){
			this.isLoading = true;
			return Promise.all([
				this.getListOfCategories().then(() => {
					this.setCurrentCategory( parseFloat( this.$route.params.id ) );
					Object.assign( this.form, this.currentCategory || {} );
					this.isLoading = false;
				})
			]);
		} else {
			if( !this.isLoading ){
				Object.assign( this.form, this.currentCategory || {} );	
			}	
		}
	},

	methods: {

		...mapActions([
			"setCurrentCategory",
			"getListOfCategories",
			"saveCategory"
		]),

		onChanged() {
			console.log('new picture loaded');
			if( this.$refs.pictureInput.file ){
				this.categoryImage = this.$refs.pictureInput.file;
				this.form.image    = this.$refs.pictureInput.file;
			} else {
				console.log( "Old browser. No support for Filereader API" );
			}
		},

		onRemoved() {
			this.categoryImage = '';
			this.form.image    = '';
		},

	    showImageUploadPanel() {
			vueSlideoutPanelService.show( {
				component: imageUploadPanel,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props: {
					sidebarTitle: 'Upload New Category Image'
				}
			} );
	    },


		handleSubmit: function(){

			if( this.categoryImage ){
				console.log('attempted upload');
				console.log( this.categoryImage );
			}

			this.isSending         = true;
			this.submitContent();
    	},

    	submitContent: function(){

    		var self = this;

			this.saveCategory( this.form );
			self.isSent    = true;
			self.isSending = false;

    	}

	}
}
</script>
<style>
a.uploadNewImageBtn {
	cursor: pointer;
}
a.uploadNewImageBtn i.fa {
	color: #fff;
}
</style>