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

							<address-form-fields
								:address1="form.address1"
								:address2="form.address2"
								:city="form.city"
								:province="form.province"
								:postalCode="form.postalCode"
								:country="form.country"
							></address-form-fields>		

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
import { Form } from '@cbCommerce/admin/classes/form';
import addressFormFields from '@cbCommerce/admin/components/address/address-form-fields';
export default {

	components: {
		addressFormFields
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
				addressDetails: this.form
			} );
		},

		saveDetails() {
			this.closePanel();
		}

	},

	created() {
		Object.assign( this.form, this.data.address || {} );
	},

	computed: {

		sideBarTitle() {
			var addressType = this.data.type;
			return ( this.data.method === 'edit' ) ? `Edit ${addressType} Address` : `Add ${addressType} Address`;
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