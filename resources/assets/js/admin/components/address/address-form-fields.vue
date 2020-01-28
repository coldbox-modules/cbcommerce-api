<template>

	<div>

		<b-form-group
			:label="$t('address_line') + ` 1`"
			label-for="address1">
			<b-form-input 
				type="text"
				id="address1"
				:required=true
				v-model.trim="address1"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t('address_line') + ` 2`"
			label-for="address2">
			<b-form-input 
				type="text"
				id="address2" 
				v-model.trim="address2"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'city' )"
			label-for="city">
			<b-form-input 
				type="text"
				id="city"
				:required=true
				v-model.trim="city"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'state' ) + `/` + $t( 'province' )"
			label-for="province">
			<b-form-input 
				type="text"
				id="province"
				:required=true
				v-model.trim="province"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'zip' ) + `/` + $t( 'postal_code' )"
			label-for="postalCode">
			<b-form-input 
				type="text"
				id="postalCode"
				:required=true
				v-model.trim="postalCode"></b-form-input>
		</b-form-group>							

		<b-form-group
			:label="$t( 'country' )"
			label-for="country">
			<b-form-input 
				type="text"
				id="country"
				:required=true
				v-model.trim="country"></b-form-input>
		</b-form-group>	

	</div>

</template>
<script>
export default {

	props: {
		address1: {
			type: String
		},
		address2: {
			type: String
		},
		city: {
			type: String
		},
		province: {
			type: String
		},
		postalCode: {
			type: String
		},
		country: {
			type: String
		}
	},

}
</script>