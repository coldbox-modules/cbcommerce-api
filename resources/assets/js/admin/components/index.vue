<template>

	<div>

		<router-view></router-view>

	</div>

</template>
``
<script>
import { mapActions, mapMutations } from "vuex";

import OrderSummary from "./orders/order-summary";
export default {
	name    : "Index",
	components: {
		OrderSummary
	},
	methods : {

		...mapMutations([
			"setActiveCategory",
			"clearActiveCategory"
		]),
		...mapActions([
			"setCurrentProduct",
			"clearCurrentProduct",
			"getCategories",
			"setCurrentOrder",
			"clearCurrentOrder",
			"clearCurrentCustomer",
			"setCurrentCustomer",
			"clearOrderProductList",
			"getListOfProducts"
		])

	},
	watch: {
		$route( to, from ){

			if( to.name === 'categories' ){
				Promise.resolve( this.clearActiveCategory() )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'categoryForm' ){
				Promise.resolve( this.setActiveCategory( to.params.id ) )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'products' ){
				Promise.resolve( this.clearCurrentProduct() )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'productForm' ){
				Promise.resolve( this.setCurrentProduct( to.params.id ) )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'orderView' ){
				return Promise.all([
					this.getListOfProducts().then(() => {} ),
					this.clearCurrentCustomer().then(() => {} ),
					this.setCurrentOrder( to.params.id ).then(() => {} ),
					this.clearOrderProductList().then(() => {} )
				]);
			}

			if( to.name === 'newOrder' ){
				return Promise.all([
					this.clearCurrentCustomer().then(() => {} ),
					this.clearCurrentOrder().then(() => {} ),
					this.clearOrderProductList().then(() => {} )
				]);
			}

			if( to.name === 'customerForm' ){
				Promise.resolve( this.setCurrentCustomer( to.params.id ) )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'customers' ){
				Promise.resolve( this.clearCurrentCustomer() )
					.catch( err => console.error( err ) );
			}

			if( to.name === 'newCustomer' ){
				Promise.resolve( this.clearCurrentCustomer() )
					.catch( err => console.error( err ) );
			}

		}
	}
};
</script>