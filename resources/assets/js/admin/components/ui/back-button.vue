<template>

	<router-link
    	:to="link"
    	:class="linkClass">{{ text }}</router-link>

</template>
<script>
export default {

	name: 'BackButton',

	props: {
		link: {
			required: true
		},
		text: {
			type    : String,
			required: true
		},
		linkClass: {
			type    : String,
			required: false,
			default : 'btn btn-primary btn-lg float-right'
		}
	}

}
</script>