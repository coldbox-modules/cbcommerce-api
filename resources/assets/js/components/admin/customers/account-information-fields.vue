<template>

	<div>

		<b-form-group
			class="mt-5"
			label="First Name"
			label-for="firstName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="firstName"
	        	v-model="firstName" />
		</b-form-group>

		<b-form-group
			label="Last Name"
			label-for="lastName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="lastName"
	        	v-model="lastName" />
		</b-form-group>

		<b-form-group
			label="Email"
			label-for="emailName">
			<b-form-input 
				type="email"
	        	required="required"
	        	class="form-control" 
	        	id="emailName"
	        	v-model="emailName" />
		</b-form-group>

	</div>

</template>
<script>
export default {

	name: "AccountInformationFields",

	props: {
		firstName: {
			type: String
		},
		lastName: {
			type: String
		},
		emailName: {
			type: String
		}
	},

	data() {
		return {}
	}

}
</script>