<template>
    <transition name="modal">
        <div class="modal-mask">
            <div class="modal-wrapper">
                <div class="modal-container">
                    <form @submit.prevent="handleSubmit">
                        <div class="modal-header header-for-light">
                            <h2><span>Request a Quote for {{cart.items.length}} Items in Your Cart</span></h2>
                        </div>

                        <div class="modal-body">
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
                                            <label for="inputText" class="control-label">Message/Additional Items Requested:</label>
                                            <div>
                                                <textarea
                                                    class="form-control"
                                                    id="inputText"
                                                    :rows="5"
                                                    v-model="formData.message"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div v-if="!isSending && isSent">
                                    <p class="alert alert-danger alert-dismissable" v-if="contactErrors.length">
                                        There was an error sending your request.  The reponse received was: {{ contactErrors.join( '. ' ) }}
                                    </p>
                                    <p v-else class="alert alert-success alert-dismissable">
                                        Thank you for submitting your request for quote. A sales representative will contact you shorlty!
                                    </p>
                                </div>

                                <div class="clearfix"></div>

                                <div
                                    v-if="isSending && !isSent"
                                    class="progress-bar"
                                    role="progressbar"
                                    aria-valuenow="100"
                                    aria-valuemin="0"
                                    aria-valuemax="100"
                                    style="width: 100%">
                                    <span class="sr-only">Requesting quote...</span>
                                </div>
                        </div>

                        <div class="modal-footer" v-if="!isSent">
                            <slot name="footer">
                                <a href="javascript:;" class="btn btn-link text-muted pull-left" @click="closeModal"><i class="fa fa-undo"></i> Cancel</a>
                                &nbsp;&nbsp;
                                <button class="btn btn-primary btn-lg pull-right" type="submit">Send Request</button>
                            </slot>
                        </div>
                        <div class="modal-footer text-center" v-else>
                            <slot name="footer-close">
                                <button class="btn btn-success btn-lg" type="button" @click="closeModal"><i class="fa fa-undo"></i> Exit</button>
                            </slot>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </transition>

</template>
<script>
import moment from "moment";
import { mapState, mapGetters } from "vuex";
import Swal from 'sweetalert2'
export default{
    data(){
        return {
            moment: moment,
            formData  : {
                name   : this.$store.getters.authUser ? this.$store.getters.authUser.fullName : "",
                email  : this.$store.getters.authUser ? this.$store.getters.authUser.email : "",
                phone  : this.$store.getters.authUser ? this.$store.getters.authUser.primaryPhone : "",
                message: '',
                hpInfo : '' //Spam honeypot field - should never be transmitted with data
            },
            contactErrors   : [],
            isSending: false,
            isSent   : false,
        };
    },

	computed : {
        ...mapGetters( [ 'authUser','apiInstance' ] ),
        ...mapState( {
            cart : state => state.cart.cart
        } )
    },

	mounted(){
		// Hide our SPAM honeypot
		$( '.fm-hp', $( this.$el ) ).css( 'display', 'none' );
    },

    methods : {
        closeModal(){
            this.$emit( "quote-modal-close" );
        },
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
			
			self.apiInstance.post.cartQuote( self.formData )
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
                    this.closeModal();
                    Swal.fire({
						type: 'success',
						title: 'Thank you for submitting your request for quote. A sales representative will contact you shorlty!',
						showConfirmButton: false,
						timer: 5000
					})
				})
				.catch(err => {
					if( err.response.data.messages.length ){
						self.contactErrors.push( err.response.data.messages[ 0 ] );
					} else {
						self.contactErrors.push( "An error occurred while attempting to send your message" );
					}
					self.isSent    = true;
                    self.isSending = false;
                    Swal.fire({
						type: 'error',
						title: 'There was an error sending your request.',
						showConfirmButton: false,
						timer: 5000
					})
				});

	        

    	}
    }

}
</script>