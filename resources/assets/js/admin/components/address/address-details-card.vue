<template>

	<b-card
		:title="title">

		<p class="card-text">
			<span v-if="customerName"><strong>{{ customerName }}</strong><br /></span>
			<span v-if="address.address1">{{ address.address1 }}<br /></span>
			<span v-if="address.address2">{{ address.address2 }}<br /></span>
			<span v-if="address.city">{{ address.city }}<br /></span>
			<span v-if="address.province">{{ address.province }}<br /></span>
			<span v-if="address.postalCode">{{ address.postalCode }}<br /></span>
			<span v-if="address.country">{{ address.country }}<br /></span>
		</p>

		<b-col cols="12" v-if="displayEditAction">
			<span 
				class="pull-right">
				<a 
					class="btn btn-success addressFormBtn"			    				
					@click="openAddressFormPanel">
					<i class="fa fa-edit"></i>
				</a>
			</span>
		</b-col>

	</b-card>

</template>
<script>
export default {

	props: {
		customerName: {
			type    : String,
			required: false,
			default : null
		},
		address: {
			type    : Object,
			required: true
		},
		title: {
			type    : String,
			required: false,
			default : null
		},
		type: {
			type    : String,
			required: false,
			default : null
		},
		displayEditAction: {
			type: Boolean,
			default: false
		}
	},

	methods: {

		openAddressFormPanel() {
			var thisAddress = this.address;
			var thisType    = this.type;
			Event.$emit( 'showAddressFormPanel', {
				address: thisAddress,
				type   : thisType
			} );
	    }

	}

}
</script>