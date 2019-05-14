<template>
    <div class="row wishlist-item-row">
		<div class="col-sm-7 wishlist-item">
            <div class="wishlist-detail-item-image col-md-4 col-sm-6 col-xs-12">
                <a :href="`/store/product/${item.sku.product.id}`">
                    <img
                        class="img-responsive"
                        :title="item.sku.product.name"
                        :alt="item.sku.product.name"
                        :src="item.image" />
                </a>
            </div>
            <div class="wishlist-item-text col-md-8 col-sm-6 col-xs-12">
                <div class="wishlist-item-name">
                    <a :href="'store/product/'+ item.sku.product.id">{{ item.sku.product.name }}</a>
                </div>
                <div class="wishlist-item-actions">
                    <ul class="list-inline">
                        <li>
                            <a 
                                v-if="item.sku.showPricing"
                                href="javascript:;"
                                @click="moveToCart"
                                v-tooltip="'Add this item to your cart'"
                                class="btn btn-primary"
                                style="width:145px;color:#fff"
                            >
                                <i class="fa fa-shopping-cart"></i> Add to cart
                            </a>

                            <a 
                                v-else
                                href="javascript:;"
                                @click="$emit( 'quote-open' )"
                                v-tooltip="'Request a quote for this item'"
                                class="btn btn-secondary"
                                style="width:145px;color:#fff"
                            >
                                    <i class="fa fa-envelope"></i> Request quote
                                </a>

                        </li>
                        
                        <li>
                            <a href="javascript:;" @click="onDeleteItem">{{$t('Remove')}}</a>
                        </li>
                    </ul>
                </div>
            </div>
		</div>
		<div class="col-sm-2">
			<div class="wishlist-item-price">
				<span class="sr-only">unit price</span>{{ item.sku.basePrice | currency }}
			</div>
		</div>
		<div class="col-sm-3">
			<div class="wishlist-item-quantity">
                <quantity-control
                    :showLabel="false"
                    :quantity="item.quantity"
					:sku="item"
                    v-on:quantityChange="onQuantityChange"
                ></quantity-control>
            </div>
		</div>
	</div>
</template>
<script>
import { mapActions, mapState } from "vuex";
import QuantityControl from '@cbCommerce/admin/components/ui/quantity-control';
export default{
    props : {
        item : {
            type : Object,
            reuquired : true
        },
        ...mapState( {
            allWishlists : ( state ) => state.wishlists.wishlists
        } )
    },
    components: {
        QuantityControl
    },
    methods : {
        ...mapActions( [ "saveWishlist", "saveWishlistItem", "addItemToCart", "deleteWishlistItem" ] ),
        onQuantityChange : function( {quantity} ){
            var self = this;
            if( !quantity ) quantity=1;

            Vue.set( self.item, "quantity", quantity );
            // send as a PATCH rather than PUT
            Vue.set( self.item, "key", "quantity" );
            Vue.set( self.item, "value", quantity );
            this.saveWishlistItem( self.item )
                    .catch( err => {
                        console.log( err );  
                    })
                    .then( xhr => {
                        Vue.delete( self.item, "key" );
                        Vue.delete( self.item, "value" );
                    });
        },
        onDeleteItem( e ){
            var self = this;
            this.deleteWishlistItem( this.item )
                .then( ( {result} ) => {
                    self.$emit( "delete-item", this.item.id )
                } )
                .catch( err => {
                    console.error( err );
                } )
        },
        moveToCart( e ){
            var $btn = $( e.currentTarget );
            $( 'i', $btn ).removeClass( 'fa-cart' ).addClass( 'fa-spin fa-spinner' );
            let payload = {
                sku : this.item.sku.id,
                quantity : this.item.quantity
            };
            this.addItemToCart( payload )
                    .then( xhr => $( 'i', $btn ).removeClass( 'fa-spin fa-spinner' ).addClass( 'fa-cart' ) )
        }
    }

}
</script>