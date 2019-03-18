<template>
	<div class="login-box block-form">
		<div class="login-box-body ">
			<div class="form-group">
				<div><label for="email">Email:</label></div>
				<input type="text" name="email"  v-model="email" class="form-control" autocomplete="false" />

				<div><label for="email">Password:</label></div>
				<input type="password" name="password" v-model="password" class="form-control" autocomplete="false"/>
				<div class="clearfix"></div>
			</div>
			<p v-if="showAuthFailure" class="alert alert-warning">
				Authentication failed.  The credentials provided were incorrect or could not be found.
			</p>
			<p><a href="#">Forgot your password?</a></p>
			<div class="form-group">
				<button class="btn btn-secondary btn-lg" @click="loginUser">Login</button>
			</div>
		</div>
	</div>
</template>
<script>
	import { mapGetters, mapActions } from "vuex";
	export default {
		props: {
			successUrl : {
				required : false,
				type : String
			}
		},
		data(){
			return {
	            email: "",
				password: "",
				showAuthFailure: false
	        }
		},
		methods: {
			...mapGetters([ "authUser" ] ),
			...mapActions( [
				"authenticate"
			] ),
			loginUser( e ){
				var self = this;
				this.authenticate( { email: this.email, password: this.password } )
						.then( xhr => {
							self.$emit( 'cbCommerce.onAuthenticationSuccess' );
							if( self.successUrl ){
								window.location.replace( self.successUrl );
							}
						})
						.catch( err => {
							self.$emit( "cbCommerce.onAuthenticationFailure" );
						} );
			}
		},
		created(){
			var self = this;

			if( self.authUser ){
				self.$emit( 'cbCommerce.onAuthenticationSuccess' );
				if( self.successUrl ){
					window.location.replace( self.successUrl );
				}
			}

			this.$on( "cbCommerce.onAuthenticationFailure", ( err ) => {
				Vue.set( self, "showAuthFailure", true );
			} )
		}
	}
</script>