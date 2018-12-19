<template>
	<div class="login-box block-form">
		<h2>Sign In to your BSR Online Account</h2>
		<div class="login-box-body ">
			<div class="form-group">
				<div><label for="username">Username:</label></div>
				<input type="text" name="username"  v-model="username" class="form-control" autocomplete="false" />

				<div><label for="username">Password:</label></div>
				<input type="password" name="password" v-model="password" class="form-control" autocomplete="false"/>
				<div class="clearfix"></div>
			</div>
			<div><a href="#">Forgot your password?</a></div>
			<div class="form-group">
				<button class="btn btn-secondary btn-lg">Login</button>
			</div>
		</div>
	</div>
</template>
<script>
	export default {
		data(){
			return {
	            username: "",
	            password: ""
	        }
		}
	}
</script>