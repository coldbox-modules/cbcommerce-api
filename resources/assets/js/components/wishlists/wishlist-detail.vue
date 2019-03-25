<template>
    <div class="wishlist-detail">
        <div v-if="isLoading" class="overlay">
     		<generic-loader :message="$t('wishlist_loader_message')"></generic-loader>
     	</div>
        <div class="col-md-12 productDetailHeader" v-if="wishlist">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s"><span>{{wishlist.name}}</span></h1>
            <p v-html="wishlist.description"></p>
        </div>

        <div class="col-md-9 col-sm-8 col-xs-12 wishlist-items" v-if="!isLoading">
            
            <wishlist-item 
                v-for="item in wishlist.items" 
                :key="item.id"
                :item="item"
                v-on:delete-item="onDeleteItem"
                v-on:save-item="onSaveItem"
            ></wishlist-item>

        </div>
        <div class="col-md-3 col-sm-4 col-xs-12" v-if="!isLoading">
            <div class="product-request">
                <a href="#" 
                    v-tooltip="'Request a quote for this item'"
                    class="btn btn-lg btn-secondary"><i class="fa fa-envelope"></i> {{ $t('request_wishlist_quote') }}</a>
            </div>
            <div v-if="pricingAvailable" class="product-cart">
                <a 
                    @click="addAllToCart"
                    v-tooltip="$t( 'Add all items to your cart' )"
                    class="btn btn-lg btn-primary"><i class="fa fa-shopping-cart"></i> {{ $t( 'Add to cart' ) }}</a>
            </div>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions, mapState } from "vuex";
export default{
    data(){
        return {
            isLoading : false,
            wishlist : null
        }
    },
    computed : {
        ...mapGetters( [ "authUser" ] ),
        wishlistId : () => {
            var locationParts = window.location.pathname.split( '/' );
            return locationParts[ locationParts.length - 1 ]; 
        },
        pricingAvailable(){
            var available = true;
            this.wishlist.items.forEach( item => {
                if( !item.sku.showPricing ) available = false;
            } );
            return available;
        }
    },
    created: function(){
        if( !this.authUser ){
            window.location.assign( '/store/account/login' );
        }
        this.isLoading = true;
        this.fetchWishlistDetail();
    },
    methods : {
        ...mapActions( [ "fetchWishlist", "saveWishlist" ] ),
        fetchWishlistDetail: function(){
            var self    = this;
            self.isLoading = true;
            self.fetchWishlist( { id : self.wishlistId, includes : "items.sku.product" } ).then( ( { data } ) => {
                Vue.set( self, "isLoading", false );
                Vue.set( self, "wishlist", data );
            } );
        },
        onDeleteItem( id ){
            var itemIndex = null;
            this.wishlist.items.forEach( ( item, index ) => {
                if( item.id === id ){
                    itemIndex = index;
                }
            } );
            if( itemIndex !== null ){
                Vue.delete( this.wishlist.items, itemIndex );    
            }
        },
        onSaveItem( id ){
            // placeholder function for any future save actions on the global wishlist detail
        }
    }
}
</script>