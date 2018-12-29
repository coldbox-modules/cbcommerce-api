<template>

	<div v-if="!this.isLoading">

		<page-header 
			:headerTitle="`Product: ${form.name}`">		
		</page-header>

		<dismissable-alert v-if="isSent && !isSending"
			alertText="The item has been updated."
			alertType="success">
		</dismissable-alert>

		<form @submit.prevent="handleSubmit">

		    <b-row>

		        <b-col cols="12">

		            <b-form-group
						label="Name"
						label-for="name">
						<b-form-input 
	                    	required="required"
	                    	class="form-control" 
	                    	id="name"
	                    	v-model="form.name" />
					</b-form-group>

		        </b-col>

		    </b-row>

		    <b-row>

		        <b-col cols="12">

					<b-form-group
						label="Categories"
						label-for="categories">
						<v-select 
							multiple 
							v-model="selectedCategories" 
							:options="options"
						></v-select>
					</b-form-group>

		        </b-col>

		    </b-row>

		    
		    <b-form-group>

			    <b-form-checkbox 
			    	v-model="form.isActive" 
			    	:model.sync="form.isActive"
					:true-value="1"
					:false-value="0">
			    	Enable Product
			    </b-form-checkbox>

			</b-form-group>


		    <div role="tablist">

		    	<b-card no-body class="mb-1">

		    		<b-card-header header-tags="header" class="p-1" role="tab">
		    			<b-btn block href="#" v-b-toggle.content>Content</b-btn>
		    		</b-card-header>
		    		<b-collapse id="content" accordion="product-accordion" role="tabpanel">
		    			<b-card-body>

						    <b-row>
						        <b-col cols="12">

									<b-form-group
										label="Short Description"
										label-for="shortDescription">
										<html-editor 
						            		height="200" 
						            		:model.sync="form.shortDescription"></html-editor>
									</b-form-group>

						        </b-col>
						    </b-row>

						    <b-row>
						        <b-col cols="12">

									<b-form-group
										label="Long Description"
										label-for="description">
										<html-editor 
						            		height="200" 
						            		:model.sync="form.description"></html-editor>
									</b-form-group>

						        </b-col>
						    </b-row>

		    			</b-card-body>
		    		</b-collapse>

		    	</b-card>


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
								:images="productImages"></gallery-list-sortable>

		    			</b-card-body>
		    		</b-collapse>

		    	</b-card>


		    	<b-card no-body class="mb-1">

		    		<b-card-header header-tags="header" class="p-1" role="tab">
		    			<b-btn block href="#" v-b-toggle.skus>SKUs</b-btn>
		    		</b-card-header>
		    		<b-collapse id="skus" accordion="product-accordion" role="tabpanel" visible>
		    			<b-card-body>

		    				<b-col cols="12" class="mb-5">
		    					<span 
		    						class="pull-right">
		    						<a 
		    							class="btn btn-success SKUBtn"			    				
		    							@click="showSKUPanel( { }, 'add' )">
		    							<i class="fa fa-plus"></i>
		    						</a>
		    					</span>
		    				</b-col>

		    				<b-col cols="12">
		    					
								<b-table
								    :items="productSKUs"
								    :fields="productSKUFields">
								    <template slot="cost" slot-scope="data">
								    	{{ data.item.cost | currency }}
								    </template>
								    <template slot="basePrice" slot-scope="data">
								    	{{ data.item.basePrice | currency }}
								    </template>
								    <template slot="isActive" slot-scope="data">
								    	<i v-if="data.item.isActive" class="fa fa-check"></i>
									</template>
								    <template slot="actions" slot-scope="data">
								        <a 
								            @click.stop="showSKUPanel( data.item, 'edit' )"
								            class="btn btn-success SKUBtn float-right">
								            <i class="fa fa-eye"></i>
								        </a>
								    </template>
								</b-table>

		    				</b-col>

		    			</b-card-body>
		    		</b-collapse>

		    	</b-card>

		    </div>


		    <hr />

		    <button type="submit" class="btn btn-secondary btn-lg">Save</button>

		    <back-button link="/products" text="Back to products"></back-button>
		    
		</form>

	</div>

</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import { mapGetters, mapActions } from "vuex";
import vSelect from 'vue-select';
import moment from "moment";
import VueImgLoader from 'vue-img-loader';
import { Form } from '@cbCommerce/admin/classes/form';
import htmlEditor from '@cbCommerce/admin/components/ui/html-editor';
import galleryList from '@cbCommerce/admin/components/images/gallery-list';
import galleryListSortable from '@cbCommerce/admin/components/images/gallery-list-sortable';
import imageUploadPanel from '@cbCommerce/admin/components/images/image-upload-panel';
import skuFormPanel from './sku-form-panel';
export default {
	name: "ProductForm",

	components: {
		htmlEditor,
		VueImgLoader,
		galleryList,
		galleryListSortable,
		imageUploadPanel,
		skuFormPanel,
		vSelect
	},

    data() {
        return {
			isLoading         : false,
			form              : new Form(),
			url               : '/api/v1/products', /* The URL to post the submission to */
			moment            : moment,
			errors            : [],
			isSending         : false,
			isSent            : false,
			isActiveChecked   : null,
			selectedCategories: [],
			productImages     : [],
			productSKUs       : [],
			productSKUFields  : {
				condition: {},
				cost     : {},
				basePrice: {},
				isActive : {},
				actions: {}
			}
        }
    },

	computed: {

		...mapGetters([
			"currentProduct",
			"currentProductID",
			"productsList"
		])

	},

	created() {
		if( !this.currentProductID ){
			this.isLoading = true;
			return Promise.all([
				this.getListOfProducts().then(() => {
					this.setCurrentProduct( this.$route.params.id );
					Object.assign( this.form, this.currentProduct || {} );
					this.fetchCategories();
					this.fetchProductImages();
					this.fetchProductSKUs();
					this.isLoading = false;
				})
			]);
		} else {
			if( !this.isLoading ){
				Object.assign( this.form, this.currentProduct || {} );
				this.fetchCategories();
				this.fetchProductImages();
				this.fetchProductSKUs();
			}
		}
	},

	mounted() {
		this.isActiveChecked = this.form.isActive;
	},

	methods: {

		...mapActions([
			"setCurrentProduct",
			"getListOfProducts",
			"saveProduct"
		]),


		fetchCategories() {
			var categories = this.$options.filters.denormalize( this.form.categories );
			if( categories.length ){
				categories.forEach( ( category ) => {
					this.selectedCategories.push( category.name );
				});
			}
		},

		fetchProductImages() {
			var media = this.$options.filters.denormalize( this.form.media );
			if( media.length ){
				this.productImages = media;
			}
		},

		fetchProductSKUs() {
			var skus = this.$options.filters.denormalize( this.form.skus );
			if( skus.length ){
				this.productSKUs = skus;
			}
		},

		handleSubmit: function(){
			this.isSending = true;
			this.submitContent();
    	},

    	submitContent: function(){

			var self = this;
			
			console.log( this.form );

			this.saveProduct( this.form );
			self.isSent    = true;
			self.isSending = false;

    	},

	    showImageUploadPanel() {
			vueSlideoutPanelService.show( {
				component: imageUploadPanel,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props: {
					sidebarTitle: 'Upload New Product Image'
				}
			} );
	    },

	    showSKUPanel( thisSKU, method ) {
			vueSlideoutPanelService.show( {
				component: skuFormPanel,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props    : {
					data: {
						sku   : thisSKU,
						method: method
					}
				}
			} );
	    }

	}
}
</script>

<style>
a.uploadNewImageBtn,
a.SKUBtn {
	cursor: pointer;
}
a.uploadNewImageBtn i.fa,
a.SKUBtn i.fa {
	color: #fff;
}
</style>