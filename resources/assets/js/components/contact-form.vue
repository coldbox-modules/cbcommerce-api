<template>

	<div>

		<form @submit.prevent="handleSubmit">
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
		                    	v-model="formData.name" />
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
		                    	v-model="formData.email" />
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
		                    	v-model="formData.phone" />
		                </div>
		            </div>
		        </div>
				<div class="col-md-12 fm-hp">
					<div class="form-group">
						<label>Do not enter text in to the following field</label>
						<input type="text" v-model="formData.hpInfo"/>
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
								:rows="messageHeight"
		                    	v-model="formData.message"></textarea>
		                </div>
		            </div>
		        </div>
		    </div>

			<div v-if="!isSending && isSent">
				<p class="alert alert-danger alert-dismissable" v-if="contactErrors.length">
					There was an error sending your messages.  The reponse received was: {{ contactErrors.join( '. ' ) }}
				</p>
				<p v-else class="alert alert-success alert-dismissable">
					Thank you, your message has been sent!
				</p>
			</div>
			<div class="clearfix"></div>
		    <button type="submit" class="pull-right btn btn-secondary btn-lg">Send</button>
			<div class="clearfix"></div>
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


	</div>

</template>

<script>
import moment from "moment";
import { mapGetters } from "vuex";
export default {

    data() {
        return {
			url   : '', /* The URL to post the submission to */
			moment: moment,
			formData  : {
				name   : '',
				email  : '',
				phone  : '',
				message: '',
				hpInfo : '' //Spam honeypot field - should never be transmitted with data
        	},
			contactErrors   : [],
			isSending: false,
			isSent   : false
        }
	},
	
	props : {
		contactSubject : {
			type : String,
			required : false
		},
		messageHeight : {
			type : Number,
			default : 15
		}
	},

	computed : {
		...mapGetters( [ 'apiInstance' ] )
	},

	mounted(){
		// Hide our SPAM honeypot
		$( '.fm-hp', $( this.$el ) ).css( 'display', 'none' );
	},

    methods: {

    	handleSubmit: function(){
			const currDateTime     = moment( new Date() );
			this.formData.fullDateTime = currDateTime;
			this.formData.date         = moment( currDateTime ).format( 'DD/MM/YYYY' );
			this.isSending         = true;
			this.submitContent();
    	},

    	submitContent: function(){

			var self = this;
			if( self.contactSubject ){
				self.formData.subject = self.contactSubject;
			}

			Vue.set( self, "contactErrors", [] );
			
			self.apiInstance.post.contactForm( self.formData )
				.then( XHR => {
					self.isSent    = true;
					self.isSending = false;
					Vue.set( 
						self, 
						"formData", 
						{
							name    : '',
							email   : '',
							phone   : '',
							message : '',
							hpInfo  : ''
						}
					);
				})
				.catch(err => {
					if( err.response.data.messages.length ){
						self.contactErrors.push( err.response.data.messages[ 0 ] );
					} else {
						self.contactErrors.push( "An error occurred while attempting to send your message" );
					}
					self.isSent    = true;
					self.isSending = false;
				});

	        

    	}

    }

}
</script>