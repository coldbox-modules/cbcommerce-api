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
		this.getCart();
	},
	computed: {
		...mapGetters([
			"cartTotalQuantity"
		])
	},
	methods: {
		...mapActions([
            "getCart"
        ])
	}
}
</script>