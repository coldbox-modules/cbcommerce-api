<template>
	<p class="text-center text-muted">
		<i class="fa fa-2x fa-spin fa-circle-o-notch"></i>
		<br>
		{{ message }}
	</p>
</template>
<script>
export default{
	props : {
		message : {
			type : String,
			required : true,
			default : "Loading data. Please wait..."
		}
	}
}
</script>