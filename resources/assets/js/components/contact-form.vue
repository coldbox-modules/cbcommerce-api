<template>

	<div>

		<form @submit.prevent="handleSubmit" v-if="!isSent && !isSending">
		    <div class="row">
		        <div class="col-md-6">
		            <div class="form-group">
		                <label for="inputFirstName" class="control-label">Name:<span class="text-error">*</span></label>
		                <div>
		                    <input
		                    	required="required"
		                    	type="text"
		                    	class="form-control"
		                    	id="inputName"
		                    	v-model="form.name" />
		                </div>
		            </div>

		        </div>
		        <div class="col-md-6">
		            <div class="form-group">
		                <label for="inputLastName" class="control-label">Email:<span class="text-error">*</span></label>
		                <div>
		                    <input
		                    	required="required"
		                    	type="email"
		                    	class="form-control"
		                    	id="inputEmail"
		                    	v-model="form.email" />
		                </div>
		            </div>
		        </div>
		        <div class="col-md-12">
		            <div class="form-group">
		                <label for="inputSubject" class="control-label">Phone:<span class="text-error">*</span></label>
		                <div>
		                    <input
		                    	required="required"
		                    	type="text"
		                    	class="form-control"
		                    	id="inputPhone"
		                    	v-model="form.phone" />
		                </div>
		            </div>
		        </div>
		        <div class="col-md-12">
		            <div class="form-group">
		                <label for="inputText" class="control-label">Message:<span class="text-error">*</span></label>
		                <div>
		                    <textarea
		                    	required="required"
		                    	class="form-control"
		                    	id="inputText"
		                    	v-model="form.message"></textarea>
		                </div>
		            </div>
		        </div>
		    </div>
		    <button type="submit" class="btn btn-secondary btn-lg">Send</button>
		</form>

		<div
			v-if="isSending && !isSent"
			class="progress-bar"
			role="progressbar"
			aria-valuenow="100"
			aria-valuemin="0"
			aria-valuemax="100"
			style="width: 100%">
	        <span class="sr-only">Sending your message</span>
	    </div>

		<div class="alert alert-success alert-dismissable" v-if="!isSending && isSent">
			<p>Thank you, your message has been sent.</p>
		</div>

	</div>

</template>

<script>
import moment from "moment";
export default {

    data() {
        return {
			url   : '', /* The URL to post the submission to */
			moment: moment,
			form  : {
				name   : '',
				email  : '',
				phone  : '',
				message: ''
        	},
			contactErrors   : [],
			isSending: false,
			isSent   : false
        }
    },

    created: function(){},

    mounted() {},

    destroyed() {},

    methods: {

    	handleSubmit: function(){
			const currDateTime     = moment( new Date() );
			this.form.fullDateTime = currDateTime;
			this.form.date         = moment( currDateTime ).format( 'DD/MM/YYYY' );
			this.isSending         = true;
			this.submitContent();
    	},

    	submitContent: function(){

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
					this.contactErrors = error.response.data.message;
				} );
			*/

    	}

    }

}
</script>