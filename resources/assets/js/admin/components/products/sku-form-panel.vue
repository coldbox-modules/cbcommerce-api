<template>

	<b-container class="mt-2">

		<b-row>

			<b-col cols="11" class="mt-2">
    
			    <h2>{{ sideBarTitle }}</h2>
			    
			</b-col>

			<b-col cols="1" class="mt-2">
				<span class="pull-right">
					<i 
						class="fa fa-close closePanelIcon" 
						@click="closePanel()"></i>
				</span>
			</b-col>
		    
		    <b-col class="mt-3">

				<b-card class="mb-1">

			    	<b-row>

			    		<b-col>

							<b-form-group
								label="Model Number"
								label-for="modelNumber">
								<b-form-input 
									type="text"
									id="modelNumber"
									:required=true
									v-model.trim="form.modelNumber"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Condition"
								label-for="condition">
									<v-select  
										v-model="form.condition" 
										label="name"
										:options="parentConditions"
									></v-select>
							</b-form-group>

							<b-form-group
								label="Sub-Condition"
								label-for="condition">
									<v-select  
										v-model="form.subCondition" 
										label="name"
										:options="childConditions"
									></v-select>
							</b-form-group>

							<b-form-group
								label="Condition Description"
								label-for="conditionDescription">
								<html-editor 
									height="200" 
									:model.sync="form.conditionDescription"></html-editor>
							</b-form-group>	


							<b-card no-body class="mb-1" v-if="data.sku.media">

								<b-card-header header-tags="header" class="p-1" role="tab">
									<b-btn block href="#" v-b-toggle.skuImages>Images</b-btn>
								</b-card-header>
								<b-collapse id="skuImages" accordion="product-accordion" role="tabpanel">
									<b-card-body>
										<gallery-list-sortable 
											:endpoint="`/store/api/v1/skus/${data.sku.id}/media`"
											:images="data.sku.media"></gallery-list-sortable>

									</b-card-body>
								</b-collapse>

							</b-card>

							<b-form-group
								label="MSRP"
								label-for="MSRP">
								<b-input-group size="lg" prepend="$">
									<b-form-input 
										type="number"
										id="MSRP" 
										:required="true"
										v-model.trim="form.MSRP"></b-form-input>
								</b-input-group>
							</b-form-group>

							<b-form-group
								label="Base Price"
								label-for="basePrice">
								<b-input-group size="lg" prepend="$">
									<b-form-input 
										type="number"
										id="basePrice"
										v-model.trim="form.basePrice"></b-form-input>
								</b-input-group>
							</b-form-group>																		

							<b-form-group
								label="Cost"
								label-for="cost">
								<b-input-group size="lg" prepend="$">
									<b-form-input 
										type="number"
										id="cost" 
										:required="true"
										v-model.trim="form.cost"></b-form-input>
								</b-input-group>
							</b-form-group>

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isActive" 
							    	:model.sync="form.isActive">
							    	Is SKU active?
							    </b-form-checkbox>

							</b-form-group>

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isConsigned" 
							    	:model.sync="form.isConsigned">
							    	Is Consignment Product
							    </b-form-checkbox>

							</b-form-group>	

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isVirtual" 
							    	:model.sync="form.isVirtual">
							    	Is this a virtual/downloadable product?
							    </b-form-checkbox>

							</b-form-group>

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.allowBackorder" 
							    	:model.sync="form.allowBackorder">
							    	Allow backorder?
							    </b-form-checkbox>

							</b-form-group>							

							<b-form-group
								label="Discontinue On"
								label-for="discontinueOn">
								<b-input-group>
									<b-input-group-prepend>
										<b-input-group-text>
											<i class="fa fa-calendar"></i>
										</b-input-group-text>
									</b-input-group-prepend>
									<datepicker 
										:value="form.discontinueOn" 
										name="discontinueOn"
										input-class="form-control"></datepicker>
								</b-input-group>								
							</b-form-group>

							<hr />

							<b-form-group
								label="Packaged Weight (lbs)"
								label-for="packagedWeight">
								<b-form-input 
									type="text"
									id="packagedWeight"
									:required=true
									v-model.trim="form.packagedWeight"></b-form-input>
							</b-form-group>							

							<b-form-group
								label="Packaging Width (in)"
								label-for="packagingX">
								<b-form-input 
									type="text"
									id="packagingX"
									:required=true
									v-model.trim="form.packagingX"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Packaging Height (in)"
								label-for="packagingY">
								<b-form-input 
									type="text"
									id="packagingY"
									:required=true
									v-model.trim="form.packagingY"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Packaging Depth (in)"
								label-for="packagingZ">
								<b-form-input 
									type="text"
									id="packagingZ"
									:required=true
									v-model.trim="form.packagingZ"></b-form-input>
							</b-form-group>

							<button 
								id="saveDetails"
								class="btn btn-success" 
								@click="saveDetails">
								Save SKU
							</button>

						</b-col>

					</b-row>

				</b-card>

			</b-col>

		</b-row>
    
    </b-container>

</template>

<script>
import Datepicker from 'vuejs-datepicker';
import htmlEditor from '@cbCommerce/admin/components/ui/html-editor';
import galleryListSortable from '@cbCommerce/admin/components/images/gallery-list-sortable';
import vSelect from 'vue-select';
import { Form } from '@cbCommerce/admin/classes/form';
import { mapState, mapActions } from 'vuex';
export default {

	components: {
		Datepicker,
		htmlEditor,
		galleryListSortable,
		vSelect
	},

	props: {
		data: {
			type    : Object,
			required: true
		}
	},

	computed : {
		sideBarTitle() {
			return ( this.data.method === 'edit' ) ? `Edit SKU Details` : `Add SKU Details`;
		},
		...mapState({
			parentConditions : state => Vue.options.filters
													.denormalize( state.globalData.productConditions )
													.filter( condition => !condition.parent.id ),
			childConditions : state => Vue.options.filters
													.denormalize( state.globalData.productConditions )
													.filter( condition => condition.parent.id )
		})
	},

	data() {
		return {
			form: new Form(),
		};
	},

	methods: {
		...mapActions([
			"saveSKU"
		]),
		closePanel() {
			this.$emit( 'closePanel', {
				skuDetails: this.form
			} );
		},

		saveDetails() {
			this.saveSKU( this.form );
			this.closePanel();
		}

	},

	created() {
		Object.assign( this.form, this.data.sku || {} );
	}

}
</script>
<style>
i.closePanelIcon { 
	cursor: pointer;
	font-size: 24px;
}
</style>