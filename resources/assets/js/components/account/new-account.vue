<template>
	<div>
		<div class="overlay" v-if="isLoading">
			<generic-loader message="We are creating your account. Please wait..."></generic-loader>
		</div>
		<div class="block-form">
			<form role="form" method="post" action="#" data-vv-scope="form-account">
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
						<p> When you create an account, you agree to the Terms of Use and consent to the Privacy Policy.</p>

						<div class="form-group">
							<button
								class="btn btn-animate btn-fluid"
								@click.prevent="create">

								Create Account
							</button>
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
		data(){
			return{
				isLoading: false,
				formFields: {
					firstName: "",
					lastName: "",
					email: "",
					password: ""
				}
			}
		},
		created(){
			// custom validation rule
			Validator.extend( 'verify_password', {
				getMessage: field => `The password must contain at least: 1 uppercase letter, 1 lowercase letter, 1 number, one special character (E.g. , . _ & ? etc), and must be at least 8 charcters long.`,
				validate: value => {
					// password rules: at least 1 uppercase, 1 lowercase, 1 number and 1 special character
					var strongRegex = new RegExp( "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})" );
					return strongRegex.test( value );
				}
			});
		},
		computed: {

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
			create(){
				var self = this;

				self.isLoading = true;

				self.$validator.validate().then( result => {
					if (!result) {
						console.log( result );
					} else {
						Promise.resolve( self.saveCustomer( this.formFields ) )
						.then( XHR => {
							if( document.referrer.indexOf( "checkout" ) > -1 ) {
							   window.location.replace( '/store/checkout' );
							} else {
								window.location.replace( 'store/shopping-cart' );
							}
							console.log( XHR.data );
						})
						.catch( err => {
							self.isLoading = false;
							console.error( err );
						});
					}
				});
			}
		}
	}
</script>