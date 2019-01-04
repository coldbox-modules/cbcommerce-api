<template>
    <div>
        <b-form-group
			label="First Name"
			label-for="firstName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="firstName"
	        	v-model="consignee.firstName" />
		</b-form-group>

		<b-form-group
			label="Last Name"
			label-for="lastName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="lastName"
	        	v-model="consignee.lastName" />
		</b-form-group>

		<b-form-group
			label="Email"
			label-for="emailName">
			<b-form-input 
				type="email"
	        	required="required"
	        	class="form-control" 
	        	id="emailName"
	        	v-model="consignee.email" />
		</b-form-group>

		<b-form-group
			label="Primary Phone"
			label-for="primaryPhone">
			<b-form-input 
				type="tel"
                pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
	        	required="required"
	        	class="form-control" 
	        	id="primaryPhone"
	        	v-model="consignee.primaryPhone" />
		</b-form-group>

		<b-form-group
			label="Secondary Phone"
			label-for="secondaryPhone">
			<b-form-input 
				type="tel"
                pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
	        	class="form-control" 
	        	id="secondaryPhone"
	        	v-model="consignee.primaryPhone" />
		</b-form-group>

        <b-form-group
			label="Address Line 1"
			label-for="address1">
			<b-form-input 
				type="text"
				id="address1"
				:required=true
				v-model.trim="consignee.address1"></b-form-input>
		</b-form-group>

		<b-form-group
			label="Address Line 2"
			label-for="address2">
			<b-form-input 
				type="text"
				id="address2" 
				v-model.trim="consignee.address2"></b-form-input>
		</b-form-group>

		<b-form-group
			label="City"
			label-for="city">
			<b-form-input 
				type="text"
				id="city"
				:required=true
				v-model.trim="consignee.city"></b-form-input>
		</b-form-group>

		<b-form-group
			label="State/Province"
			label-for="province">
			<b-form-input 
				type="text"
				id="province"
				:required=true
				v-model.trim="consignee.province"></b-form-input>
		</b-form-group>

		<b-form-group
			label="ZIP/Postal Code"
			label-for="postalCode">
			<b-form-input 
				type="text"
				id="postalCode"
				:required=true
				v-model.trim="consignee.postalCode"></b-form-input>
		</b-form-group>							

		<b-form-group
			label="Country"
			label-for="country">
			<b-form-input 
				type="text"
				id="country"
				:required=true
				v-model.trim="consignee.country"></b-form-input>
		</b-form-group>	


    </div>
</template>
<script>
    import accountInformationFields from "./account-information-fields";
    export default{
        props : {
            consignee : {
                required : true
            }
        },
        components: {
            accountInformationFields
        }
    }
</script>