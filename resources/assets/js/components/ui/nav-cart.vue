<template>

	<div>
		<span class="cart-icon">
			<span class="cart-count">{{ this.cartTotalQuantity }}</span>
		</span> <span class="hidden-xs">&nbsp; Cart</span>
	</div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {

	created() {
		this.getCart();
		this.getWishlists( { includes : "items" } );
	},
	computed: {
		...mapGetters([
			"cartTotalQuantity"
		])
	},
	methods: {
		...mapActions([
			"getCart",
			"getWishlists"
        ])
	}
}
</script>