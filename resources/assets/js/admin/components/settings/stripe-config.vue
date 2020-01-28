<template>
	
	<div>

		<page-header headerTitle="Stripe Configuration"></page-header>

		<dismissable-alert v-if="isSent && !isSending"
			:alertText="$t( 'settings_saved' )"
			alertType="success">
		</dismissable-alert>

		<b-form @submit.prevent="handleSubmit">

			<b-row>

				<b-col cols="6">

					<b-form-group
						:label="$t( 'setting_api_key' )"
						label-for="apiKey">
						<b-form-input 
							id="apiKey"
							:required="true"
							v-model.trim="form.apiKey">
						</b-form-input>
					</b-form-group>

			    </b-col>

			</b-row>

			<button type="submit" class="btn btn-secondary btn-lg">Save</button>

			<back-button link="/" :text="$t( 'setting_back_dashboard' )"></back-button>

		</b-form>

	</div>

</template>
<script>
import { mapGetters, mapActions } from "vuex";
import { Form } from '@cbCommerce/admin/classes/form';
export default {

	name: "StripeConfig",
	data() {
		return {
			isLoading: false,
			form     : new Form(),
			url      : '', /* The URL to post the submission to */
			errors   : [],
			isSending: false,
			isSent   : false
		}
	},

	created() {

		Object.assign( this.form, this.currentCustomer || {} );

	},

	methods: {

		handleSubmit() {
			this.isSending = true;
			this.submitContent();
    	},

    	submitContent() {

    		var self = this;

    		// Mocking sending the form data
    		// Axios below will handle it in real life
	        window.setTimeout(
	            function(){
					self.isSent    = true;
					self.isSending = false;
	            },
	            500
	        );

	        /*
			axios.post( this.url , this.form )
				.then( ( response ) => {
					console.log( response );
				} )
				.catch( ( error ) => {
					this.errors = error.response.data.message;
				} );
			*/

    	}

	}

}
</script>