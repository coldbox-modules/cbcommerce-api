<template>
    <span>
        <v-popover  v-if="wishlists && wishlists.results.length > 1" class="text-center">
            
            <a 
                v-tooltip="{ content: $t('wishlist_add_item') }"
                :title="$t('wishlist_add_item')"
                class="addToCart has-tooltip product-wishlist tooltip-target">
                <i :class="targetIconClass"></i>
            </a>

            <template slot="popover" class="text-center">
                <div class="form-group">
                    <label>{{$t( 'wishlists_select_label' )}}:</label>
                    <select @input="onAddItem" class="form-control form-select">
                        <option value="">--- Select One ---</option>
                        <option
                            v-for="wishlistId in wishlists.results"
                            :key="`wishlist_select_${skuId}_${wishlistId}`"
                            :value="wishlistId"
                        >
                        {{ wishlists.resultsMap[ wishlistId ].name }}
                        </option>
                    </select>
                </div>
                <a class="btn btn-small btn-link text-ultra-muted" v-close-popover><i class="fa fa-undo"></i> Cancel</a>
            </template>

        </v-popover>
        <a 
            v-else
            @click="onAddItem"
            v-tooltip="{ content: $t('wishlist_add_item') }"
            :title="$t('wishlist_add_item')"
            v-bind:class="{ 'addToCart has-tooltip':true ,'product-wishlist' : true, 'in-wishlist' : inDefaultWishlist }">
            <i :class="targetIconClass"></i>
        </a>
        <br/>
    </span>
</template>
<script>
import { mapActions, mapGetters, mapState } from "vuex";
export default{
    props: {
        skuId : {
            type : String,
            required : true
        }
    },
    data(){
        return{
            isAdding : false
        }
    },
    computed:{
        ...mapGetters(['authUser']),
        ...mapState({
            wishlists : state => state.wishlists.wishlists,
            inDefaultWishlist( state ){
                if( !this.wishlists ) return false;
                let defaultWishlist = this.wishlists.resultsMap[ this.wishlists.results[ 0 ] ];
                return defaultWishlist.items.filter( item => item.FK_sku === this.skuId  ).length;
            }
        }),
        targetIconClass(){
            return this.isAdding ? 'fa fa-spin fa-spinner' : this.$t('wishlist_icon')
        }
    },
    methods : {
        ...mapActions(["addItemToWishlist"]),
        onAddItem( e ){
            var self = this;
            if(  $( e.target ).hasClass( 'form-control' ) ){
                // close popover
                $( 'a.text-muted', self.$el ).click();
                var $actionTarget = $( 'a.product-wishlist', self.$el );
            } else {
                var $actionTarget = $( e.currentTarget );
            }
            Vue.set( this, "isAdding", true );
            
            if( !self.authUser ){
                window.location.assign( '/store/account/login' );
            }
            else {
                // give ourselves a few milliseconds to let the UI update
                setTimeout( function(){

                    let wishlist = $( e.target ).hasClass( 'form-control' ) ? self.wishlists.resultsMap[ $( e.target ).val() ] : self.wishlists.resultsMap[ self.wishlists.results[ 0 ] ];
                    
                    self.addItemToWishlist( { sku : self.skuId, wishlist : wishlist } )
                            .then( () => {
                                Vue.set( self, "isAdding", false );
                                $actionTarget.addClass( 'in-wishlist' );
                                $actionTarget.closest( '.product' ).addClass( 'in-wishlist' );
                                // click outside the popover to close it
                                $actionTarget.parent().click();
                            } )
                            .catch( err => console.error( err ) )
                }, 300 )
            }
        }
    }
}
</script>