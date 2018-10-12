<template>

	<div class="mt-5">
		<div 
			class="row"
			v-for="address in addresses"
			:key="address._id">
			<address-list-item :address="address" :type="type"></address-list-item>
		</div>
	</div>

</template>
<script>
import AddressListItem from './address-list-item.vue';
export default {

	props: [
		'addresses',
		'type'
	],

	components: {
		AddressListItem
	}

}
</script>