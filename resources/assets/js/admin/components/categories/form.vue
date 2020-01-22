<template>

	<div>

		<div v-if="!this.isLoading">

	        <page-header :headerTitle="$t( 'category' ) + `${ form.name == undefined ? '' : ': ' + form.name }`"></page-header>

			<dismissable-alert v-if="isSent && !isSending"
				:alertText="$t( 'category_updated' )"
				alertType="success">
			</dismissable-alert>

			<form @submit.prevent="handleSubmit">
			    
			    <b-row>

			        <b-col cols="12">

			            <b-form-group
							:label="$t( 'category_name' )"
							label-for="categoryName">
							<b-form-input 
		                    	required="required"
		                    	class="form-control" 
		                    	id="categoryName"
		                    	v-model="form.name" />
						</b-form-group>

			        </b-col>

			    </b-row>

			    <b-row>

			        <b-col cols="12">

			            <b-form-group
							:label="$t( 'category_description' )"
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
				    			<b-btn block href="#" v-b-toggle.images>{{ $t( 'images' ) }}</b-btn>
				    		</b-card-header>
				    		<b-collapse id="images" accordion="product-accordion" role="tabpanel">
				    			<b-card-body>
									<gallery-list-sortable 
										:images="activeCategory.media"
										:endpoint="`/store/api/v1/product-categories/${activeCategory.id}/media`"></gallery-list-sortable>

				    			</b-card-body>
				    		</b-collapse>

				    	</b-card>

					</b-col>

				</b-row>


			    <b-row>
			        
			        <b-col cols="12">
						<b-form-group :label="$t( 'category_enable' )">
							<b-form-radio-group
								v-model="form.isActive"
								:options="booleanOptions"
								name="isActive"
							></b-form-radio-group>
						</b-form-group>
			        </b-col>

			    </b-row>
				
			    <button type="submit" class="btn btn-secondary btn-lg">
					<i v-if="isSending" class="fa fa-spin fa-spinner"></i> 
					{{ $t( 'save' ) }}
				</button>

			    <back-button link="/categories" :text="$t( 'categories_back' )"></back-button>
			    
			</form>

		</div>

	</div>

</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import { mapGetters, mapActions, mapMutations } from "vuex";
import moment from "moment";
import VueImgLoader from 'vue-img-loader';
import { Form } from '@cbCommerce/admin/classes/form';
import htmlEditor from '@cbCommerce/admin/components/ui/html-editor';
import galleryList from '@cbCommerce/admin/components/images/gallery-list';
import galleryListSortable from '@cbCommerce/admin/components/images/gallery-list-sortable';
export default {
	name: "CategoryForm",

	components: {
		htmlEditor,
		VueImgLoader,
		galleryList,
		galleryListSortable
	},

    data() {
        return {
			isLoading     : false,
			form          : new Form(),
			url           : '', /* The URL to post the submission to */
			moment        : moment,
			categoryImage : null,
			errors        : [],
			isSent        : false,
			isSending     : false,
			categoryImages: [],
			booleanOptions : [
				{ text: this.$t( 'yes' ), value: true },
				{ text: this.$t( 'no' ), value: false }
			]
        }
    },

	computed: {
		...mapGetters([
			"activeCategory",
			"activeCategoryID",
			"categoriesListArray"
		]),
		categoryId(){
			return this.$route.params.id
		}
	},

	created() {
		var self = this;
		Vue.set( self, "isLoading", true );
		Event.$on( "saveImageDetails", function( imageData ){
			self.updateCategoryImage( imageData );
		} );
		Event.$on( "deleteMediaItem", function( imageData ){
			self.deleteCategoryImage( imageData );
		} );
		Event.$on( "mediaUploadSuccess", function( imageData ){
			self.insertCategoryImage( imageData );
		});
		Event.$on( "onMediaSort", event => {
			event.items.forEach( eventItem => {
				this.updateCategoryImageField( { href: eventItem.item.href, field: "displayOrder", value : eventItem.sort } );
			})
		})

		if( self.categoryId ){
			return Promise.all([
				this.getCategory( self.$route.params.id, { includes : "parent,children" }  ).then(() => {
					Vue.set( self, "form", new Form( self.activeCategory ) );
					Vue.set( self, "isLoading", false );
				})
			]);
		} else {
			this.$store.commit( "setActiveCategory", {} );
			Vue.set( self, "isLoading", false );
		}
	},

	beforeDestroy(){
		Event.$off( "saveImageDetails", this.listener );
		Event.$off( "deleteMediaItem", this.listener );
		Event.$off( "onMediaUploadSuccess", this.listener );
		Event.$off( "onMediaSort", this.listener );
	},

	methods: {
		...mapMutations([
			"insertCategoryImage"
		]),
		...mapActions([
			"getCategories",
			"getCategory",
			"saveCategory",
			"updateCategoryImage",
			"deleteCategoryImage",
			"updateCategoryImageField"
		]),
		handleSubmit: function(){
			this.isSending         = true;
			this.submitContent();
    	},
    	submitContent: function(){
			var self = this;
			self.form.includes = "children,parent";
			this.saveCategory( self.form );
			Vue.set( self, "isSent", true );
			Vue.set( self, "isSending", false );
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