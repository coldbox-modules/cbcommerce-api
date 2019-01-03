<template>

	<div class="col-md-12 mb-2">

		<address-details-card
			:type="type"
			:displayEditAction=true
			:address="address"
			@showAddressFormPanel="showAddressFormPanel">
		</address-details-card>

	</div>

</template>
<script>
import { vueSlideoutPanelService } from 'vue2-slideout-panel';
import addressDetailsCard from '@cbCommerce/admin/components/address/address-details-card';
import addressSidebar from '@cbCommerce/admin/components/address/address-sidebar';
export default {

	components: {
		addressDetailsCard,
		addressSidebar
	},

	props: [
		'address',
		'type'
	],

	methods: {

		showAddressFormPanel() {
			var thisAddress = this.address;
			var thisType    = this.type;
			vueSlideoutPanelService.show( {
				component: addressSidebar,
				width    : '1020px',
				cssClass : 'slideout-panel-overall',
				props    : {
					data: {
						address: thisAddress,
						method : 'edit',
						type   : thisType
					},
				}
			} );
	    }

	}

}
</script>
<style>
a.addressFormBtn {
	cursor: pointer;
}
a.addressFormBtn i.fa {
	color: #fff;
}
</style>