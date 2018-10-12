<template>

	<div>
		<span class="bsr-cart-icon">
			<span class="cart-count">{{ this.cartTotalQuantity }}</span>
		</span> <span class="hidden-xs">&nbsp; Cart</span>
	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {

	created() {

	},

	computed: {
		...mapGetters([
			"cartTotalQuantity"
		])
	}
}
</script>