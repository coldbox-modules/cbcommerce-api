<template>
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
                            	type="text"
                            	class="form-control"
                            	id="email"
                            	name="email"
                            	v-validate="'required|email'"
                            	data-vv-as="Email"
                            	v-model="email">

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
                            	type="text"
                            	class="form-control"
                            	id="firstName"
                            	name="firstName"
                            	v-validate="'required'"
                            	data-vv-as="First Name"
                            	v-model="firstName">

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
                            	type="text"
                            	class="form-control"
                            	id="lastName"
                            	name="lastName"
                            	v-validate="'required'"
                            	data-vv-as="Last Name"
                            	v-model="lastName">

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
								type="password"
								name="password"
								v-model="password"
								class="form-control"
								autocomplete="false"
								data-vv-as="password"
								v-validate="'required|min:8'"/>

							<span
                            	class="text-danger"
                            	v-show="errors.has('form-account.password')">

                            	{{ errors.first( 'form-account.password' ) }}
                            </span>
						</div>
	                </div>
	                <div class="form-group">
	                	<label for="password">Confirm Password:</label>
	                	<div>
		                	<input
		                		name="password_confirmation"
		                		type="password"
		                		class="form-control"
		                		v-validate="'required|confirmed:password'"
		                		data-vv-as="password"
		                		>

		                	<span
                            	class="text-danger"
                            	v-show="errors.has('form-account.password_confirmation')">

                            	{{ errors.first( 'form-account.password_confirmation' ) }}
                            </span>
		                </div>
		            </div>
		            <div class="form-group">
		            	<button
			     			class="btn btn-animate btn-fluid"
			     			@click="create"
			     			:disabled="!isValidated">

			     			Create Account
		     			</button>
		            </div>
	            </div>
	        </div>
		</form>
	</div>
</template>
<script type="text/javascript">
	export default{
		data(){
			return{
				isValidated: false,
				firstName: "",
				lastName: "",
				email: "",
				password: ""
			}
		},
		methods: {
			create(){
				console.log( 'creating' );
			}
		}
	}
</script>