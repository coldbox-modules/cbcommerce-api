<template>
    <div>
        <b-form-group
			:label="$t( 'first_name' )"
			label-for="firstName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="firstName"
	        	v-model="consignor.firstName" />
		</b-form-group>

		<b-form-group
			:label="$t( 'last_name' )"
			label-for="lastName">
			<b-form-input 
	        	required="required"
	        	class="form-control" 
	        	id="lastName"
	        	v-model="consignor.lastName" />
		</b-form-group>

		<b-form-group
			:label="$t( 'Email' )"
			label-for="emailName">
			<b-form-input 
				type="email"
	        	required="required"
	        	class="form-control" 
	        	id="email"
	        	v-model="consignor.email" />
		</b-form-group>

		<b-form-group
			:label="$t( 'primary_phone' )"
			label-for="primaryPhone">
			<b-form-input 
				type="tel"
                pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
	        	required="required"
	        	class="form-control" 
	        	id="primaryPhone"
	        	v-model="consignor.primaryPhone" />
		</b-form-group>

		<b-form-group
			:label="$t( 'secondary_phone' )"
			label-for="secondaryPhone">
			<b-form-input 
				type="tel"
                pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
	        	class="form-control" 
	        	id="secondaryPhone"
	        	v-model="consignor.primaryPhone" />
		</b-form-group>

        <b-form-group
			:label="$t( 'address_line' ) + `1`"
			label-for="address1">
			<b-form-input 
				type="text"
				id="address1"
				:required=true
				v-model.trim="consignor.address1"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'address_line' ) + `2`"
			label-for="address2">
			<b-form-input 
				type="text"
				id="address2" 
				v-model.trim="consignor.address2"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'city' )"
			label-for="city">
			<b-form-input 
				type="text"
				id="city"
				:required=true
				v-model.trim="consignor.city"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'state' ) + `/` + $t( 'province' )"
			label-for="province">
			<b-form-input 
				type="text"
				id="province"
				:required=true
				v-model.trim="consignor.province"></b-form-input>
		</b-form-group>

		<b-form-group
			:label="$t( 'zip' ) + `/` + $t( 'postal_code' )"
			label-for="postalCode">
			<b-form-input 
				type="text"
				id="postalCode"
				:required=true
				v-model.trim="consignor.postalCode"></b-form-input>
		</b-form-group>							

		<b-form-group
			:label="$t( 'country' )"
			label-for="country">
			<b-form-input 
				type="text"
				id="country"
				:required=true
				v-model.trim="consignor.country"></b-form-input>
		</b-form-group>	


    </div>
</template>
<script>
    import accountInformationFields from "./account-information-fields";
    export default{
        props : {
            consignor : {
                required : true
            }
        },
        components: {
            accountInformationFields
        }
    }
</script>