<template>

	<div>

        <page-header
            :headerTitle="$t( 'categories' )"
            :displayToolBarButton="true"
            routeName="newCategory"
            buttonIconClass="fa fa-plus">    
        </page-header>
		<p class="text-muted">{{ $t( 'categories_order' ) }} Click the <i class="fa fa-pencil"></i> icon to edit.</p>
	
		<div class="nestable-categories-list nested-expandable col-xs-12">
			<generic-loader v-if="!categoryTree" :message="$t( 'categories_loading' )"></generic-loader>
			<vue-nestable 
				v-else 
				v-model="categoryTree"
				v-on:input="reviseHierarchy"
			>
				<vue-nestable-handle
				class="nestable-category-item"
				slot-scope="{ item }"
				:item="item">
					<div class="row">
						<div class="col col-1">
							<a href="javascript:;" class="btn btn-sm text-muted" style="cursor:move">
								<i class="fa fa-bars"></i>
							</a>
						</div>
						<div class="col">
							<strong>{{item.name}}</strong>
						</div>
						<div class="col col-6" v-html="item.description"></div>
						<div class="col col-2">
							<a 
								href="javascript:;"
								@click="toggleExpand"
								class="btn btn-default btn-sm float-right"
								v-if="item.children && item.children.length"
							>
								<i class="fa fa-caret-down fa-2x"></i>
							</a>
							

							<a 
								:href="`/store/category/${item.id}`"
								target="blank"
								class="btn btn-link btn-sm float-right"
								v-if="item.children && item.children.length"
								v-b-tooltip.hover
								:title="$( 'category_site' )"
							>
								<i class="fa fa-globe"></i>
							</a>
							
							<router-link 
							:to="{ name: 'categoryForm', params: { id: item.id } }" 
							class="btn btn-default btn-sm float-right">
								<i class="fa fa-pencil"></i>
							</router-link>
						</div>
					</div>
				
				</vue-nestable-handle>
			</vue-nestable>
		</div>
	</div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import moment from "moment";
import TableRow from "./table-row";
export default {

	components: {
		TableRow
	},

    data() {
    	return {
			filterParams : {
				isActive : 1,
				sortOrder : 'displayOrder ASC',
				isNull : 'FK_parent',
				// four levels deep by default
				includes : "children.children.children.children.children"
			},
			categoryTree : null,
			variations: 0

    	}
    },

    created() {
		this.setCategories( null );
    	this.fetchCategories();
    },

    mounted() {},

    computed: {
    	...mapGetters([
			"categoriesListArray"
		]),
		topLevelIds(){
			return categoryTree.map( cat => cat.id );
		}
    },

    methods: {
    	
    	...mapActions([
			"getCategories",
			"saveCategory"
		]),
		...mapMutations([
			"setCategories"
		]),
		toggleExpand( e ){
			var $btn = $( e.currentTarget );
			var $item = $btn.closest( '.nestable-item' );
			$( '.nestable-list', $item ).slideToggle();
			$( 'i', $btn ).toggleClass( 'fa-caret-down' ).toggleClass( 'fa-caret-up' );
		},
		reviseHierarchy( topLevels ){
			Vue.set( this, "variations", this.variations + 1 );
			if( this.variations <= 1 ) return;
			var self = this;
			// the arguments provided are the newly adjusted levels, from the top down.
			topLevels.forEach( ( cat, index ) => {
				let parentId = "";
				let displayOrder = index + 1;
				if( cat.FK_parent !== parentId || cat.displayOrder !== displayOrder  ){
					cat.FK_parent = parentId;
					cat.displayOrder = displayOrder;
					self.saveCategory( 
						{
							"id" : cat.id,
							"displayOrder" : displayOrder,
							"FK_parent" : parentId

						} 
					);
				}
				self.reviseChildHierarcies( cat );
			} );
		},
		reviseChildHierarcies( parent ){
			var self = this;
			parent.children.forEach( ( cat, index ) => {
				let parentId = parent.id;
				let displayOrder = index + 1;

				if( cat.FK_parent !== parentId || cat.displayOrder !== displayOrder  ){
					cat.FK_parent = parentId;
					cat.displayOrder = displayOrder;
					self.saveCategory( 
						{
							"id" : cat.id,
							"displayOrder" : displayOrder,
							"FK_parent" : parentId

						}
					 );
				}
				self.reviseChildHierarcies( cat )
			} );
		},
    	fetchCategories(){
			const self = this;
			Vue.set( this, "variations", 0 );
			Vue.set( self, "categoryTree", null );
			this.getCategories( this.filterParams )
					.then( ( result ) => {
						Vue.set( self, "categoryTree", self.$options.filters.denormalize( result ) );
					} )
					.catch( ( err ) => console.error( err ) );

    	}

    },

}
</script>