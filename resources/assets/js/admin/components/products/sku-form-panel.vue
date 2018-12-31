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
								label="Condition"
								label-for="condition">
								<b-form-input 
									type="text"
									id="condition"
									:required=true
									v-model.trim="form.condition"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Condition Description"
								label-for="conditionDescription">
								<html-editor 
									height="200" 
									:model.sync="form.conditionDescription"></html-editor>
							</b-form-group>

							<b-form-group
								label="Sub-Condition"
								label-for="subCondition">
								<b-form-input 
									type="text"
									id="subCondition"
									:required=true
									v-model.trim="form.subCondition"></b-form-input>
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

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isActive" 
							    	:model.sync="form.isActive">
							    	Enable SKU
							    </b-form-checkbox>

							</b-form-group>

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isPrimary" 
							    	:model.sync="form.isPrimary">
							    	Is primary SKU?
							    </b-form-checkbox>

							</b-form-group>	

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isVirtual" 
							    	:model.sync="form.isVirtual">
							    	Is this a virtual product?
							    </b-form-checkbox>

							</b-form-group>

							<b-form-group>

							    <b-form-checkbox 
							    	v-model="form.isConsigned" 
							    	:model.sync="form.isConsigned">
							    	Is this consigned?
							    </b-form-checkbox>

							</b-form-group>																											
							<b-form-group
								label="On Hand"
								label-for="onHand">
								<b-form-input 
									type="text"
									id="onHand" 
									:required="true"
									v-model.trim="form.onHand"></b-form-input>
							</b-form-group>

							<b-form-group
								label="MSRP"
								label-for="MSRP">
								<b-form-input 
									type="text"
									id="MSRP" 
									:required="true"
									v-model.trim="form.MSRP"></b-form-input>
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
								label="Packaged Weight"
								label-for="packagedWeight">
								<b-form-input 
									type="text"
									id="packagedWeight"
									:required=true
									v-model.trim="form.packagedWeight"></b-form-input>
							</b-form-group>							

							<b-form-group
								label="Packaging Dimensions (X)"
								label-for="packagingX">
								<b-form-input 
									type="text"
									id="packagingX"
									:required=true
									v-model.trim="form.packagingX"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Packaging Dimensions (Y)"
								label-for="packagingY">
								<b-form-input 
									type="text"
									id="packagingY"
									:required=true
									v-model.trim="form.packagingY"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Packaging Dimensions (Z)"
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
								Save Details
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
import { Form } from '@cbCommerce/admin/classes/form';
export default {

	components: {
		Datepicker,
		htmlEditor
	},

	props: {
		data: {
			type    : Object,
			required: true
		}
	},

	data() {
		return {
			form: new Form(),
		};
	},

	methods: {

		closePanel() {
			Event.$emit( 'closePanel', {
				skuDetails: this.form
			} );
		},

		saveDetails() {
			this.closePanel();
		}

	},

	created() {
		Object.assign( this.form, this.data.sku || {} );
	},

	computed: {

		sideBarTitle() {
			return ( this.data.method === 'edit' ) ? `Edit SKU Details` : `Add SKU Details`;
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