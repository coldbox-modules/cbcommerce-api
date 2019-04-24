<template>
	<div class="login-box block-form">
        <div v-if="authenticating" class="overlay">
            <generic-loader :message="$t( 'authenticating_message' )"></generic-loader>
        </div>
		<div v-if="authenticated" class="overlay">
            <generic-loader :message="$t( 'authenticated_message' )"></generic-loader>
        </div>
		<div class="login-box-body" v-if="resetPassword">
			<div class="form-group">
				<div><label for="email">{{$t( 'Email' )}}:</label></div>
				<input type="text" name="email"  v-model="email" class="form-control" autocomplete="false" />

			</div>
			<p v-if="resetRequestProcessed" class="alert alert-success">
				{{$t( 'password_reset_success_message' )}}
			</p>
			
			<div class="form-group" v-if="!resetRequestProcessed">
				<button class="btn btn-primary btn-lg" @click="processReset">{{ $t( 'Reset Password' ) }}</button>
				<a @click="resetPassword=false"><i class="fa fa-undo"></i> {{ $t( 'Cancel' ) }}</a>
			</div>
			<div class="form-group" v-else>
				<button class="btn btn-success btn-lg" @click="resetPassword=false"><i class="fa fa-undo"></i> {{ $t( 'Back to Login' ) }}</button>
			</div>
		</div>
		<div class="login-box-body" v-else>
			<div class="form-group">
				<div><label for="email">{{$t( 'Email' )}}:</label></div>
				<input type="text" name="email"  v-model="email" class="form-control" autocomplete="false" />

				<div><label for="email">{{$t( 'Password' )}}:</label></div>
				<input type="password" name="password" v-model="password" class="form-control" autocomplete="false"/>
				<div class="clearfix"></div>
			</div>
			<p v-if="showAuthFailure" class="alert alert-warning">
				{{$t( 'authentication_failure_message' )}}
			</p>
			<p><a @click="resetPassword=true">{{ $t( 'forgot_password_prompt' ) }}</a></p>
			<div class="form-group">
				<button class="btn btn-secondary btn-lg" @click="loginUser">{{ $t( 'Login' ) }}</button>
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
				showAuthFailure: false,
				authenticating : false,
				authenticated : false,
				resetPassword : false,
				resetRequestProcessed : false,
	        }
		},
		computed : {
			...mapGetters([ "authUser", "apiInstance" ] ),
			redirectUrl(){
				return this.successUrl || document.referrer.indexOf( "login" ) === -1 ? document.referrer : '/'
			}
		},	
		methods: {
			...mapActions( [
				"authenticate",
				"requestReset"
			] ),
			loginUser( e ){
				var self = this;
				Vue.set( self, "authenticating", true );
				this.authenticate( { email: this.email, password: this.password } )
						.then( xhr => {
							console.log( "Authenticated!" )
							Vue.set( self, "authenticating", false );
							Vue.set( self, "authenticated", true );
							self.$emit( 'cbCommerce.onAuthenticationSuccess' );
							window.location.replace( self.redirectUrl );
						})
						.catch( err => {
							console.log( "Not authenticated!" )
							Vue.set( self, "authenticating", false );
							self.$emit( "cbCommerce.onAuthenticationFailure" );
						} );
			},
			processReset(){
				var self = this;
				this.apiInstance.post.authentication.resetPassword( this.email )
						.then( xhr => {
							self.email = "";
							self.resetRequestProcessed = true;
						} )
						.catch( err => {
							self.resetRequestProcessed = false;
							console.log( err );
						} );
			}
		},
		mounted(){
			var self = this;
	
			if( self.authUser ){
				self.$emit( 'cbCommerce.onAuthenticationSuccess' );
				Vue.set( self, "authenticating", true );
				window.location.replace( self.redirectUrl );
			}

			this.$on( "cbCommerce.onAuthenticationFailure", ( err ) => {
				Vue.set( self, "showAuthFailure", true );
			} );
		}
	}
</script>