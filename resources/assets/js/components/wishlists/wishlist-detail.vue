<template>
    <div class="wishlist-detail">
        <div v-if="isLoading" class="overlay">
     		<generic-loader :message="$t('wishlist_loader_message')"></generic-loader>
     	</div>
        <div class="col-md-12 header-for-light" v-if="wishlist">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">{{ $t( 'Wishlist' ) }}: <span contenteditable="true" @blur="updateWishlistName">{{wishlist.name}}</span></h1>
            <p v-html="wishlist.description"></p>
        </div>

        <div class="col-md-9 col-sm-8 col-xs-12 wishlist-items" v-if="!isLoading">
            
            <wishlist-item 
                v-for="item in wishlist.items" 
                :key="item.id"
                :item="item"
                v-on:delete-item="onDeleteItem"
                v-on:save-item="onSaveItem"
                v-on:quote-open="toggleModal"
            ></wishlist-item>
            
            <div 
                v-if="!wishlist.items.length"
                class="alert alert-info text-center"
            >
                {{ $t( 'wishlist_no_items' ) }}
                <br><br>
            </div>

        </div>
        <div class="col-md-3 col-sm-4 col-xs-12" v-if="!isLoading">
            <div v-if="wishlist.items.length" class="product-request">
                <a  href="javascript:;"
                    @click="toggleModal" 
                    style="margin-bottom:30px"
                    v-tooltip="'Request a quote for this item'"
                    class="btn btn-lg btn-secondary btn-fluid"><i class="fa fa-envelope"></i> {{ $t('request_wishlist_quote') }}</a>
            </div>

            <div v-if="wishlist.items.length && pricingAvailable" class="product-cart">
                <a 
                    @click="addAllToCart"
                     style="margin-bottom:30px"
                    v-tooltip="$t( 'Add all items to your cart' )"
                    class="btn btn-lg btn-primary btn-fluid"><i class="fa fa-shopping-cart"></i> {{ $t( 'Add to cart' ) }}</a>
            </div>

            <v-popover class="text-center">
                <button class="tooltip-target btn btn-link text-muted">
                <i class="fa fa-trash"></i> {{ $t( 'delete_wishlist' ) }}
                </button>
                <template slot="popover" class="text-center">
                    <p class="alert alert-danger text-center">
                        <i class="fa fa-warning"></i><br>{{$t( 'delete_wishlist_confirm' )}}<br><br>
                        <button class="btn btn-primary" @click="onDeleteWishlist"><i class="fa fa-trash"></i> {{$t( 'confirmed_proceed' )}}</button>
                    </p>
                    <a class="text-muted" v-close-popover><i class="fa fa-undo"></i> Cancel</a>
                </template>
            </v-popover>
        </div>
        <wishlist-quote-modal v-if="showQuoteModal" v-on:quote-modal-close="toggleModal" :wishlist="wishlist"></wishlist-quote-modal>
    </div>
</template>
<script>
import { mapGetters, mapActions, mapState } from "vuex";
import WishlistQuoteModal from "@cbCommerce/components/wishlists/wishlist-quote-modal";
export default{
    data(){
        return {
            isLoading : false,
            wishlist : null,
            showQuoteModal : false
        }
    },
    components : {
        WishlistQuoteModal
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
        ...mapActions( [ "fetchWishlist", "saveWishlist", "deleteWishlist", "addItemToCart" ] ),
        toggleModal(){
            Vue.set( this, "showQuoteModal", !this.showQuoteModal );
        },
        fetchWishlistDetail: function(){
            var self    = this;
            self.isLoading = true;
            self.fetchWishlist( { id : self.wishlistId, includes : "items.sku.product" } ).then( ( { data } ) => {
                Vue.set( self, "isLoading", false );
                Vue.set( self, "wishlist", data );
            } );
        },
        updateWishlistName( e ){
            Vue.set( this.wishlist, "name", $( e.target ).html() );
            this.saveWishlist( { id : this.wishlist.id, name : this.wishlist.name } );
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
        addAllToCart(){
            var self = this;
            this.wishlist.items.forEach( item => {
                self.addItemToCart( { sku : item.FK_sku, quantity: item.quantity } );
            } );
        },
        onSaveItem( id ){
            // placeholder function for any future save actions on the global wishlist detail
        },
        onDeleteWishlist( e ){
            var $btn = $( e.currentTarget );
            $( 'i', $btn ).removeClass( 'fa-trash' ).addClass( 'fa-spin fa-spinner' );
            this.deleteWishlist( this.wishlist.id )
                    .then( () =>{
                        window.location.assign( '/store/wishlists' )
                    } )
                    .catch( err => {
                        console.error( err );
                    } );
        }
    }
}
</script>