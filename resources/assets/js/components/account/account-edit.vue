<template>
	<div>
		<div class="overlay" v-if="isLoading">
			<generic-loader message="Updating account. Please wait..."></generic-loader>
		</div>
		<div class="block-form">
			<form role="form" action="javascript:void(0)" data-vv-scope="form-account">
				<div class="row">
					<div class="col-md-6 col-md-offset-3">
						<div class="form-group">
							<label for="email" class="control-label">Email:
								<span class="text-danger">*</span>
							</label>
							<div>
								<input
									id="email"
									name="email"
									type="text"
									class="form-control"
									v-validate="'required|email'"
									data-vv-as="Email"
									v-model="formFields.email">

								<span
									class="text-danger"
									v-show="errors.has('form-account.email')">

									{{ errors.first( 'form-account.email' ) }}
								</span>
							</div>
						</div>
						<div class="form-group">
							<label for="firstName" class="control-label">First Name:
								<span class="text-danger">*</span>
							</label>
							<div>
								<input
									id="firstName"
									name="firstName"
									type="text"
									class="form-control"
									v-validate="'required'"
									data-vv-as="First Name"
									v-model="formFields.firstName">

								<span
									class="text-danger"
									v-show="errors.has('form-account.firstName')">

									{{ errors.first( 'form-account.firstName' ) }}
								</span>
							</div>
						</div>
						<div class="form-group">
							<label for="lastName" class="control-label">Last Name:
								<span class="text-danger">*</span>
							</label>
							<div>
								<input
									id="lastName"
									name="lastName"
									type="text"
									class="form-control"
									v-validate="'required'"
									data-vv-as="Last Name"
									v-model="formFields.lastName">

								<span
									class="text-danger"
									v-show="errors.has('form-account.lastName')">

									{{ errors.first( 'form-account.lastName' ) }}
								</span>
							</div>
						</div>
						<div class="form-group">
							<label for="password">Password:</label>
							<span class="text-danger">*</span>
							<div>
								<input
									id="password"
									name="password"
									ref="password"
									type="password"
									class="form-control"
									autocomplete="false"
									v-model="formFields.password"
									v-validate="'verify_password'"
									data-vv-name="password"
									/>

								<span
									class="text-danger"
									v-show="errors.has('form-account.password')">

									{{ errors.first( 'form-account.password' ) }}
								</span>
							</div>
						</div>
						<div class="form-group">
							<label for="password">Confirm Password:</label>
							<span class="text-danger">*</span>
							<div>
								<input
									id="passwordconfirmation"
									name="passwordconfirmation"
									type="password"
									class="form-control"
									data-vv-name="passwordconfirmation"
									v-validate="'required|confirmed:password'"
									data-vv-as="password"
									>

								<span
									class="text-danger"
									v-show="errors.has('form-account.passwordconfirmation')">

									{{ errors.first( 'form-account.passwordconfirmation' ) }}
								</span>
							</div>
						</div>
						
                        <p v-if="errorMessage" class="alert alert-danger">
							{{ errorMessage }}
						</p>

                        <p v-if="successMessage" class="alert alert-success">
							{{ successMessage }}
						</p>
						
                        <div class="form-group">
							<a
								href="javascript:;"
								class="btn btn-animate btn-fluid"
								@click="update">

								Update Account
							</a>
							
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</template>
<script type="text/javascript">
	import { mapState, mapGetters, mapActions } from "vuex";
	import { Validator } from 'vee-validate';

	const validator = new Validator();

	export default{
		props : {
			postProcessLogin : {
				type : Boolean,
				default : true
			}
		},
		data(){
			return{
				isLoading: false,
                errorMessage : null,
                successMessage : null,
                passwordChangeRequired : false,
				formFields: {
					firstName: "",
					lastName: "",
					email: "",
					password: "",
					autologin : this.postProcessLogin
				}
			}
		},
		created(){
			Validator.extend( 'verify_password', {
				getMessage: field => `The password must contain at least: 1 uppercase letter, 1 lowercase letter, 1 number, one special character (E.g. , . _ & ? etc), and must be at least 8 charcters long.`,
				validate: value => {
					// password rules: at least 1 uppercase, 1 lowercase, 1 number and 1 special character
					var strongRegex = new RegExp( "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*?+])(?=.{8,})" );
					return strongRegex.test( value );
				}
            });

            Object.assign( 
                this.formFields, 
                {
                    id : this.authUser.id,
                    firstName : this.authUser.firstName,
                    lastName : this.authUser.lastName,
                    email : this.authUser.email
                }
            );
            
		},
		computed: {
            ...mapGetters( [ "authUser" ] )
		},
		mounted(){
			validator.attach( {
				name: 'password',
				rules: 'required|min:8|verify_password'
			});
		},
		methods: {
			...mapActions([
				"saveCustomer"
			]),
			update( e ){
				var self = this;
				self.isLoading = true;
				self.errorMessage = null;
				self.successMessage = null;
				self.$validator.validate().then( result => {
					if (!result) {
						console.log( result );
						self.isLoading=false;
					} else {
						self.saveCustomer( self.formFields )
						.then( XHR => {
							self.successMessage = "Your account has been successfully updated";
						})
						.catch( err => {
							if( err.response && err.response.data ){
								self.errorMessage = "Your account not be updated.  The message received was: " + err.response.data.messages.join( '. ' );
							}
						})
						.then( xhr => { 
							self.isLoading = false;
						} );
					}
				});
			}
		}
	}

</script>