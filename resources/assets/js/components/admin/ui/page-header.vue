<template>

	<div :class="containerClass">

	    <h1 :class="headerClass">{{ headerTitle }}</h1>

	    <div 
	    	v-if="displayToolBarButton" 
	    	class="btn-toolbar mb-2 mb-md-0">
	        <router-link 
	            :to="{ name: routeName }" 
	            class="btn btn-success float-right">
	            <i :class="buttonIconClass"></i>
	        </router-link>
	    </div>

	</div>

</template>
<script>
export default {

	props: {
		containerClass: {
			type    : String,
			required: false,
			default : 'd-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom'
		},
		headerTitle: {
			type    : String,
			required: true
		},
		headerClass: {
			type    : String,
			required: false,
			default : 'h2'
		},
		displayToolBarButton: {
			type   : Boolean,
			default: false
		},
		routeName: {
			type   : String,
			default: ''
		},
		buttonIconClass: {
			type    : String,
			required: false,
			default : ''
		}
	}

}
</script>