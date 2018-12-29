<template>

	<b-alert 
		:show="dismissCountDown"
		dismissible
		fade
		:variant="alertType"
		@dismissed="dismissCountDown=0"
		@dismiss-count-down="countDownChanged">
		<h4 class="alert-heading">{{ headingText }}</h4>
		<p>{{ alertText }}</p>
		<hr />
		<small>{{ countdownDisplay }}</small>
	</b-alert>

</template>
<script>
export default {

	props: {
		headingText: {
			type    : String,
			required: false,
			default : null
		},
		alertText: {
			type    : String,
			required: true
		},
		alertType: {
			type     : String,
			required : true,
			default  : 'info',
			validator: ( value ) => [
				'primary',
				'secondary',
				'success',
				'danger',
				'warning',
				'info',
				'light',
				'dark'
			].includes( value )
		},
		dismissSecs: {
			type    : Number,
			required: false,
			default : 5
		}
	},

	data() {
		return {
			dismissCountDown: null
		}
	},

	created() {
		this.dismissCountDown = this.dismissSecs;
	},

	methods: {

		countDownChanged( dismissCountDown ) {
			this.dismissCountDown = dismissCountDown
		}

	},

	computed: {

		countdownDisplay() {
			return `This notification will dismiss in ${ this.dismissCountDown }`;
		}

	}

}
</script>