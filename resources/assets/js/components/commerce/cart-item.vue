<template>
	<div class="row cart-product-row">
		<div class="col-sm-7">
			<div class="cart-product">
				<div class="cart-product-image">
					<a :href="`/store/product/${item.product.id}`">
                        <img
                            :title="item.product.name"
                            :alt="item.product.name"
                            :src="item.sku.image ? item.sku.image.href : item.product.image.href" />
                    </a>
                </div>
                <div class="cart-product-text">
					<div class="cart-product-name">
						<a :href="'store/product/'+ item.product.id">{{ item.product.name }}</a>
					</div>
					<div class="cart-product-actions">
						<ul class="list-inline">
							<li>
								<a href="" @click.prevent="deleteCartItem( item.sku.id )">Remove</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-sm-2">
			<div class="cart-product-price">
				<span class="sr-only">unit price</span>${{ item.sku.basePrice }}
			</div>
		</div>
		<div class="col-sm-3">
			<div class="cart-product-quantity">
                <quantity-control
                    :showLabel="false"
                    :quantity="item.quantity"
                    v-on:quantityChange="quantityChangeReaction"
                ></quantity-control>
            </div>
		</div>
	</div>
</template>
<script type="text/javascript">
	import { mapGetters, mapActions } from "vuex";
	import QuantityControl from '@cbCommerce/components/admin/ui/quantity-control';

	export default{
		components:{
			QuantityControl
		},
		props: {
	        item: {
	            required: true,
	            type: Object
	        },
	    },
	    methods: {
	        ...mapActions([
	            "deleteCartItem"
	        ]),

	        quantityChangeReaction: function( {quantity, sku} ){
				if(! quantity ) quantity=1;
	            Vue.set( this.item, "quantity", quantity );
	        }
		}
	}
</script>