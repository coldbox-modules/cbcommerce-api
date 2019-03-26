<template>
    <span>
        <v-popover  v-if="wishlists && wishlists.results.length > 1" class="text-center">
            
            <a 
                v-tooltip="{ content: $t('wishlist_add_item') }"
                :title="$t('wishlist_add_item')"
                class="product-wishlist tooltip-target">
                <i :class="$t('wishlist_icon')"></i>
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
            v-bind:class="{ 'product-wishlist' : true, 'in-wishlist' : inDefaultWishlist }">
            <i :class="$t('wishlist_icon')"></i>
        </a>
    </span>
</template>
<script>
import { mapActions, mapState } from "vuex";
export default{
    props: {
        skuId : {
            type : String,
            required : true
        }
    },
    computed:{
        ...mapState({
            wishlists : state => state.wishlists.wishlists,
            inDefaultWishlist( state ){
                if( !this.wishlists ) return false;
                let defaultWishlist = this.wishlists.resultsMap[ this.wishlists.results[ 0 ] ];
                return defaultWishlist.items.filter( item => item.FK_sku === this.skuId  ).length;
            }
        })
    },
    methods : {
        ...mapActions(["addItemToWishlist"]),
        onAddItem( e ){

            if(  $( e.target ).hasClass( 'form-control' ) ){
                 // close popover
                $( 'a.text-muted', this.$el ).click();
                var $actionTarget = $( 'a.product-wishlist', this.$el );
            } else {
                var $actionTarget = $( e.currentTarget );
            }
            
            $( 'i', $actionTarget ).removeClass( this.$t('wishlist_icon') ).addClass( 'fa fa-spin fa-spinner' );

            let wishlist = $( e.target ).hasClass( 'form-control' ) ? this.wishlists.resultsMap[ $( e.target ).val() ] : this.wishlists.resultsMap[ this.wishlists.results[ 0 ] ];
            
            this.addItemToWishlist( { sku : this.skuId, wishlist : wishlist } )
                    .then( () => {
                        $( 'i', $actionTarget ).removeClass( 'fa fa-spin fa-spinner' ).addClass( this.$t('wishlist_icon') );
                        $actionTarget.addClass( 'in-wishlist' );
                    } )
                    .catch( err => console.error( err ) )
        }
    }
}
</script>