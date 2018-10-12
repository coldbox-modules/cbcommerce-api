<template>

	<div>

		<b-form-group
			label="Address Line 1"
			label-for="address1">
			<b-form-input 
				type="text"
				id="address1"
				:required=true
				v-model.trim="address1"></b-form-input>
		</b-form-group>

		<b-form-group
			label="Address Line 2"
			label-for="address2">
			<b-form-input 
				type="text"
				id="address2" 
				v-model.trim="address2"></b-form-input>
		</b-form-group>

		<b-form-group
			label="City"
			label-for="city">
			<b-form-input 
				type="text"
				id="city"
				:required=true
				v-model.trim="city"></b-form-input>
		</b-form-group>

		<b-form-group
			label="State/Province"
			label-for="province">
			<b-form-input 
				type="text"
				id="province"
				:required=true
				v-model.trim="province"></b-form-input>
		</b-form-group>

		<b-form-group
			label="ZIP/Postal Code"
			label-for="postalCode">
			<b-form-input 
				type="text"
				id="postalCode"
				:required=true
				v-model.trim="postalCode"></b-form-input>
		</b-form-group>							

		<b-form-group
			label="Country"
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