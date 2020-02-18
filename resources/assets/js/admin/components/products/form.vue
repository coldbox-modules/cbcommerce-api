<template>

	<div v-if="!this.isLoading">

		<page-header 
			v-if="!isNewProduct"
			:headerTitle="$t( 'product' ) + `: ${form.name}`">		
		</page-header>
		<page-header 
			v-else
			:header-title="$t( 'product_create' )">		
		</page-header>

		<dismissable-alert v-if="isSent && !isSending"
			:alertText="$t( 'product_updated' )"
			alertType="success">
		</dismissable-alert>

		<form @submit.prevent="handleSubmit">

		    <b-row>

		        <b-col cols="12">

		            <b-form-group
						:label="$t( 'name' )"
						label-for="name">
						<b-form-input 
	                    	required="required"
	                    	class="form-control" 
	                    	id="name"
	                    	v-model="form.name" />
					</b-form-group>

		        </b-col>

		    </b-row>
		    
			<b-form-group :label="$t( 'product_enable' )">
			 	<b-form-radio-group
					v-model="form.isActive"
					:options="booleanOptions"
					name="isActive"
				></b-form-radio-group>
			</b-form-group>

		    <b-row>

		        <b-col cols="12">

					<b-form-group
						:label="$t( 'categories' )"
						label-for="categories">
						<v-select 
							v-if="categoriesListArray.length"
							multiple 
							v-model="form.categories" 
							label="name"
							:options="categoriesListArray"
						></v-select>
						<p v-else class="text-center text-muted"><i class="fa fa-spin fa-spinner fa-2x"></i><br>{{ $t( 'categories_loading' ) }}</p>
					</b-form-group>

		        </b-col>

		    </b-row>

		    <div role="tablist">

		    	<b-card no-body class="mb-1">

		    		<b-card-header header-tags="header" class="p-1" role="tab">
		    			<b-btn block href="#" v-b-toggle.content>{{ $t( 'content' ) }}</b-btn>
		    		</b-card-header>
		    		<b-collapse id="content" accordion="product-accordion" role="tabpanel" visible>
		    			<b-card-body>

						    <b-row>
						        <b-col cols="12">

									<b-form-group
										:label="$t( 'short_description' )"
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
										:label="$t( 'long_description' )"
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
				
				<b-row v-if="isNewProduct">

					<b-col cols="12">

						<p class="alert alert-info text-center">{{ $t( 'product_save' ) }}</p>

					</b-col>

				</b-row>

		    	<b-card no-body class="mb-1" v-if="currentProduct.id">

		    		<b-card-header header-tags="header" class="p-1" role="tab">
		    			<b-btn block href="#" v-b-toggle.images>{{ $t( 'images' ) }}</b-btn>
		    		</b-card-header>
		    		<b-collapse id="images" accordion="product-accordion" role="tabpanel">
		    			<b-card-body>
							<gallery-list-sortable 
								:endpoint="`/store/api/v1/products/${currentProduct.id}/media`"
								:images="currentProduct.media"></gallery-list-sortable>

		    			</b-card-body>
		    		</b-collapse>

		    	</b-card>


		    	<b-card no-body class="mb-1" v-if="currentProduct.id">

		    		<b-card-header header-tags="header" class="p-1" role="tab">
		    			<b-btn block href="#" v-b-toggle.skus>{{ $t( 'product_skus ') }}</b-btn>
		    		</b-card-header>
		    		<b-collapse id="skus" accordion="product-accordion" role="tabpanel">
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
								    :items="currentProduct.skus"
								    :fields="productSKUFields">
								    <template v-slot:cell(modelNumber)="data">
								    	{{ data.item.modelNumber }}
								    </template>
								    <template v-slot:cell(condition)="data">
								    	{{ data.item.FK_condition ? productConditions.resultsMap[ data.item.FK_condition ].name : 'New' }}
								    </template>
								    <template v-slot:cell(basePrice)="data">
								    	{{ data.item.basePrice | currency }}
								    </template>
								    <template v-slot:cell(isActive)="data">
								    	<i v-if="data.item.isActive" class="fa fa-check"></i>
									</template>
								    <template  v-slot:cell(actions)="data">
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

		    <button type="submit" class="btn btn-secondary btn-lg">{{ $t( 'save' ) }}</button>

		    <back-button link="/products" :text="$t( 'products_back' )"></back-button>
		    
		</form>

	</div>

</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import { mapGetters, mapActions, mapMutations, mapState } from "vuex";
import vSelect from 'vue-select';
import moment from "moment";
import { Form } from '@cbCommerce/admin/classes/form';
import htmlEditor from '@cbCommerce/admin/components/ui/html-editor';
import galleryList from '@cbCommerce/admin/components/images/gallery-list';
import galleryListSortable from '@cbCommerce/admin/components/images/gallery-list-sortable';
import skuFormPanel from './sku-form-panel';
export default {
	name: "ProductForm",

	components: {
		htmlEditor,
		galleryList,
		galleryListSortable,
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
			productSKUFields  : [
				{ 
					key: 'modelNumber'
				},
				{ 
					key: 'condition'
				},
				{ 
					key: 'basePrice'
				},
				{ 
					key: 'isActive'
				},
				{ 
					key: 'actions'
				}
			],
			booleanOptions : [
				{ text: this.$t( 'yes' ), value: true },
				{ text: this.$t( 'no' ), value: false }
			]
        }
    },

	computed: {

		...mapGetters([
			"currentProduct",
			"currentProductID",
			"productsList",
			"categoriesListArray"
		]),
		...mapState({
			productConditions : state => state.globalData.productConditions
		}),
		isNewProduct(){
			return !this.$route.params.id || this.$route.params.id.indexOf( "new" ) > -1;
		}

	},

	created() {
		var self = this;
		Vue.set( self, "isLoading", true );
		Event.$on( "saveImageDetails", function( imageData ){
			self.updateProductImage( imageData );
		} );
		Event.$on( "deleteMediaItem", function( imageData ){
			self.deleteProductImage( imageData );
		} );
		Event.$on( "mediaUploadSuccess", function( imageData ){
			self.insertProductImage( imageData );
		});
		Event.$on( "onMediaSort", event => {
			event.items.forEach( eventItem => {
				this.updateProductImageField( { href: eventItem.item.href, field: "displayOrder", value : eventItem.sort } );
			})
		})

		this.getCategories( { excludes: "media", isNotNull : "parent", maxrows : 500 } );
		if( !this.isNewProduct ){
			this.getProduct( { id: this.$route.params.id, includes: "skus.condition,skus.subCondition,skus.consignor,categories", activeSKUsOnly : false } )
					.then( product => {
						Vue.set( self, "form", new Form( product ) );
						Vue.set( self, "isLoading", false );
					})
					.catch( err => {
						Vue.set( self, "isLoading", false );
					});
		} else {
			this.setActiveProduct({
				isActive : true
			});
			Vue.set( self, "isLoading", false );
		}
	},
	beforeDestroy(){
		Event.$off( "saveImageDetails", this.listener );
		Event.$off( "deleteMediaItem", this.listener );
		Event.$off( "onMediaUploadSuccess", this.listener );
		Event.$off( "onMediaSort", this.listener );
	},
	mounted() {
		this.isActiveChecked = this.form.isActive;
	},

	methods: {
		...mapMutations([
			"insertProductImage",
			"setActiveProduct"
		]),
		...mapActions([
			"getCategories",
			"getProduct",
			"setCurrentProduct",
			"getListOfProducts",
			"saveProduct",
			"updateProductImage",
			"deleteProductImage",
			"updateProductImageField"
		]),

		handleSubmit: function(){
			this.isSending = true;
			this.submitContent();
    	},

    	submitContent: function(){

			var self = this;
			self.isSending = true;
			self.isSent=false;

			var redirectRoute = this.isNewProduct;

			this.saveProduct( this.form ).then( response => {
				if( redirectRoute ){
					this.$router.push( { name : 'productForm', params : { id : response.id } } );
					self.isSent    = true;
					self.isSending = false;
				} else {
					Vue.set( self, "form", new Form( response ) );
					self.isSent    = true;
					self.isSending = false;
				}
			});

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