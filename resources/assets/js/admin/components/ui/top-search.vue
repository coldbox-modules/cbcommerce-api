<template>

	<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">

		<router-link 
			to="/" 
			class="navbar-brand col-sm-3 col-md-2 mr-0">CBCommerce Admin</router-link>

		<input 
			v-if="authUser"
			class="form-control form-control-dark w-100" 
			type="text" 
			placeholder="Search" 
			aria-label="Search" />

		<ul class="navbar-nav px-3">
			<li v-if="authUser" class="nav-item text-nowrap">
				<a class="nav-link" href="##">Sign out</a>
			</li>
		</ul>
	</nav>

</template>

<script>
import { mapGetters } from "vuex";
export default {
	name    : "TopSearch",
	computed : {
		...mapGetters([ "authUser" ] )
	}
};
</script>