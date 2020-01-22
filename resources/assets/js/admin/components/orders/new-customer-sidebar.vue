<template>

<div class="container mt-2">

		<div class="row">

			<div class="col-md-11 mt-2">
    
			    <h2></h2>
			    
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

						    <div class="col-md-12">

								<account-info-fields
									:firstName="firstName"
									:lastName="lastName"
									:emailName="emailName">
								</account-info-fields>

								<b-card-header header-tags="header" class="p-1 mt-5" role="tab">
					    			<b-btn block href="#" v-b-toggle.billingAddress>{{ $t( 'billing_address' ) }}</b-btn>
					    		</b-card-header>
					    		<b-collapse 
					    			id="billingAddress"
					    			accordion="billingAddress-accordion" 
					    			role="tabpanel">

					    			<b-card-body>

									    <b-row>
									        <b-col cols="12">

												<address-form-fields
													:address1="billingAddress.address1"
													:address2="billingAddress.address2"
													:city="billingAddress.city"
													:province="billingAddress.province"
													:postalCode="billingAddress.postalCode"
													:country="billingAddress.country"
												></address-form-fields>	

									        </b-col>
									    </b-row>

					    			</b-card-body>

					    		</b-collapse>

								<b-card-header header-tags="header" class="p-1 mb-5" role="tab">
					    			<b-btn block href="#" v-b-toggle.shippingAddress>{{ $t( 'shipping_address' ) }}</b-btn>
					    		</b-card-header>
					    		<b-collapse 
					    			id="shippingAddress"
					    			accordion="shippingAddress-accordion" 
					    			role="tabpanel">

					    			<b-card-body>

									    <b-row>
									        <b-col cols="12">

												<address-form-fields
													:address1="shippingAddress.address1"
													:address2="shippingAddress.address2"
													:city="shippingAddress.city"
													:province="shippingAddress.province"
													:postalCode="shippingAddress.postalCode"
													:country="shippingAddress.country"
												></address-form-fields>	

									        </b-col>
									    </b-row>

					    			</b-card-body>

					    		</b-collapse>

								<button 
									id="saveDetails"
									class="btn btn-success" 
									@click="saveDetails">
									{{ $t( 'save_details' ) }}
								</button>

						    </div>

					    </div>

					</div>

				</div>

			</div>

		</div>
    
    </div>

</template>
<script>
import AccountInfoFields from '@cbCommerce/admin/components/customers/account-information-fields';
import addressFormFields from '@cbCommerce/admin/components/address/address-form-fields';
export default {

	components: {
		AccountInfoFields,
		addressFormFields
	},

	data() {
		return {
			firstName      : null,
			lastName       : null,
			emailName      : null,
			billingAddress: {
				address1  : null,
				address2  : null,
				city      : null,
				province  : null,
				postalCode: null,
				country   : null
			},
			shippingAddress: {
				address1  : null,
				address2  : null,
				city      : null,
				province  : null,
				postalCode: null,
				country   : null
			}
		}
	},

	methods: {

		closePanel() {
			Event.$emit( 'closePanel', {
				
			} );
		},

		saveDetails() {
			this.closePanel();
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